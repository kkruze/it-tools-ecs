data "aws_caller_identity" "current" {}


# Values that identify the GitHub repository allowed to deploy.
locals {
  github_owner  = "kkruze"
  github_repo   = "it-tools-ecs"
  github_branch = "main"

  github_owner_id = "260774464"
  github_repo_id  = "1345736943"

  state_bucket = "kruze-it-tools-ecs-tfstate"
}


# IAM role that GitHub Actions will assume through OIDC.
resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }

      Action = "sts:AssumeRoleWithWebIdentity"

      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"

          "token.actions.githubusercontent.com:sub" = [
            "repo:${local.github_owner}@${local.github_owner_id}/${local.github_repo}@${local.github_repo_id}:ref:refs/heads/${local.github_branch}",
            "repo:${local.github_owner}@${local.github_owner_id}/${local.github_repo}@${local.github_repo_id}:pull_request"
          ]
        }
      }
    }]
  })
}

# What GitHub Actions is allowed to do AFTER it assumes the role.
resource "aws_iam_role_policy" "github_actions" {
  name = "${var.project_name}-github-actions-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      # Main Terraform infrastructure.
      {
        Sid    = "TerraformInfrastructure"
        Effect = "Allow"

        Action = [
          "ec2:*",
          "elasticloadbalancing:*",
          "ecs:*",
          "logs:*",
          "acm:*",
          "route53:*"
        ]

        Resource = "*"
      },

      # Docker needs this before it can log in to ECR.
      {
        Sid    = "ECRAuthentication"
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },

      # Allow CI/CD to work with only our project's ECR repository.
      {
        Sid    = "ECRRepository"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:DescribeRepositories",
          "ecr:DescribeImages",
          "ecr:ListImages"
        ]

        Resource = "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${var.project_name}-ecr"
      },

      # Terraform needs to locate the state bucket.
      {
        Sid    = "TerraformStateBucket"
        Effect = "Allow"

        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]

        Resource = "arn:aws:s3:::${local.state_bucket}"
      },

      # Terraform can read/write the MAIN stack state and lock file.
      {
        Sid    = "TerraformStateObjects"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "arn:aws:s3:::${local.state_bucket}/it-tools-ecs/*"
      },

      # The main Terraform stack creates the ECS execution IAM role.
      {
        Sid    = "ProjectIAMRoles"
        Effect = "Allow"

        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:UpdateAssumeRolePolicy",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy",
          "iam:ListInstanceProfilesForRole",
          "iam:PassRole"
        ]

        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.project_name}-*"
      },

      # Terraform attaches AWS's ECS execution policy to our ECS role.
      {
        Sid    = "ReadECSTaskExecutionPolicy"
        Effect = "Allow"

        Action = [
          "iam:GetPolicy",
          "iam:GetPolicyVersion"
        ]

        Resource = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
      },

      # AWS may need to create its own internal ECS / ELB service roles.
      {
        Sid    = "ServiceLinkedRoles"
        Effect = "Allow"

        Action   = "iam:CreateServiceLinkedRole"
        Resource = "*"

        Condition = {
          StringEquals = {
            "iam:AWSServiceName" = [
              "ecs.amazonaws.com",
              "elasticloadbalancing.amazonaws.com"
            ]
          }
        }
      },

      # Allows Terraform/AWS CLI to confirm which AWS account it is using.
      {
        Sid      = "IdentityCheck"
        Effect   = "Allow"
        Action   = "sts:GetCallerIdentity"
        Resource = "*"
      }
    ]
  })
}
