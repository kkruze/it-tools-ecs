# IT-Tools on AWS ECS

A production-style DevOps project that deploys **IT-Tools** to **AWS ECS Fargate** using Docker, Terraform, GitHub Actions, Route 53, ACM, and Amazon ECR.

The project demonstrates a complete deployment workflow from **build → test → scan → provision → deploy → validate**.

## Architecture

![AWS ECS Architecture](docs/screenshots/architecture-diagram.png)

### Application Flow

`User → Route 53 → HTTPS ALB → Target Group → ECS Fargate → NGINX → IT-Tools`

### Deployment Flow

`GitHub → GitHub Actions → OIDC / IAM → Docker Build → Amazon ECR → Terraform → ECS Fargate`

## Live Demo

![Live Demo](docs/screenshots/live-demo.gif)

The demo shows the application running through the custom HTTPS domain and responding normally during live use.

## What I Built

- Containerized IT-Tools using a multi-stage Docker build
- Deployed the application to AWS ECS Fargate
- Placed ECS tasks inside private subnets with no public IP
- Exposed the application through an Application Load Balancer
- Configured HTTP to HTTPS redirection
- Added TLS using AWS Certificate Manager
- Connected the application to `tm.magidali.com` through Route 53
- Provisioned AWS infrastructure using modular Terraform
- Stored Docker images in Amazon ECR
- Tagged Docker images using the Git commit SHA
- Used GitHub Actions OIDC authentication instead of long-lived AWS credentials
- Added pre-deployment container health testing
- Added Trivy image vulnerability scanning
- Added Terraform validation with TFLint and Checkov
- Added post-deployment `/health` verification
- Used S3 for remote Terraform state

## CI/CD

### Pull Requests

Pull requests targeting `main` run:

```text
terraform fmt
terraform validate
TFLint
terraform plan
```

### Deployment

A push to `main` triggers:

```text
Build Docker Image
        ↓
Run Container
        ↓
Test /health
        ↓
Trivy Security Scan
        ↓
Push SHA-Tagged Image to ECR
        ↓
Terraform Plan
        ↓
Terraform Apply
        ↓
Deploy to ECS Fargate
        ↓
Verify Live /health Endpoint
```

## AWS Infrastructure

```text
VPC
├── 2 Public Subnets
│   ├── Application Load Balancer
│   └── 1 NAT Gateway
│
└── 2 Private Subnets
    └── ECS Fargate Service
```

The Application Load Balancer spans two public subnets for availability.

The ECS service runs inside private subnets with **no public IP** and accepts application traffic only from the ALB security group on port `8080`.

A single NAT Gateway provides outbound internet access for the private subnets while keeping the project cost-conscious.

## Security

- GitHub Actions authenticates to AWS using OIDC
- No long-lived AWS access keys are stored in GitHub
- ECS tasks run inside private subnets
- ECS tasks have no public IP
- HTTPS is provided through AWS ACM
- ECS only accepts application traffic from the ALB
- ECR image scanning is enabled
- ECR image tags are immutable
- Docker images are scanned with Trivy before deployment
- Terraform is checked with TFLint and Checkov
- Application health is verified before and after deployment

## Challenges & Solutions

### Docker Architecture Mismatch

The image was initially built on Apple Silicon, which caused an architecture mismatch when deploying to ECS.

**Solution:** Built the production container explicitly for `linux/amd64` using Docker Buildx.

### ALB Health Check Failures

The target group initially failed health checks because the application did not expose the expected `/health` endpoint correctly.

**Solution:** Added a dedicated NGINX `/health` route returning `200 OK` and configured the ALB target group to use that endpoint.

### Container Vulnerability Detected in CI

Trivy blocked a deployment after detecting a HIGH severity vulnerability in the Alpine `pcre2` package.

**Solution:** Updated the vulnerable package during the Docker build, rebuilt the image, and verified that the security scan passed before deployment continued.

### Secure GitHub-to-AWS Authentication

The deployment pipeline required AWS access without storing permanent credentials in GitHub.

**Solution:** Configured GitHub Actions to assume an AWS IAM role through OIDC.

## Deployment Evidence

### Successful CI/CD Deployment

![GitHub Actions Deployment](docs/screenshots/deploy-workflow.png)

### ECS Service

![ECS Service](docs/screenshots/ecs-service.png)

### Healthy Load Balancer Target

![Healthy Target Group](docs/screenshots/target-group-healthy.png)

### Live Application

![Live Application](docs/screenshots/live-app.png)

### Application Health Endpoint

![Health Check](docs/screenshots/health-check.png)

## Tech Stack

**AWS:** ECS Fargate, ECR, Application Load Balancer, Route 53, ACM, VPC, IAM, CloudWatch, S3

**DevOps:** Terraform, Docker, GitHub Actions, Trivy, Checkov, TFLint

**Application:** IT-Tools, NGINX

## Repository Structure

```text
.
├── app/
├── infra/
│   ├── bootstrap/
│   └── modules/
├── .github/
│   └── workflows/
├── docs/
│   └── screenshots/
├── Dockerfile
├── nginx.conf
└── README.md
```

## Infrastructure Lifecycle

```text
Provision → Deploy → Validate → Destroy
```

The project is designed so the runtime AWS infrastructure can be destroyed after testing and documentation are complete, avoiding unnecessary cloud costs.

---

**Magdi Ali**  
DevOps Engineer