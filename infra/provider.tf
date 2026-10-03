terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "it-tools-ecs"
      Environment = "dev"
      ManagedBy   = "Terraform"
      Owner       = "Magdi Ali"
    }
  }
}
