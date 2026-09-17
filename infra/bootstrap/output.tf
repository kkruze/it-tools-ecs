output "repository_url" {
  value = module.ecr.repository_url
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}
