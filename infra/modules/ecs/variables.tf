variable "project_name" {
  type        = string
  description = "Project name used for ECS resources"
}

variable "aws_region" {
  type        = string
  description = "The AWS region"
}
variable "image_uri" {
  type        = string
  description = "Container image URI used by the ECS task"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs where ECS Fargate tasks will run"
}

variable "ecs_sg_id" {
  type        = string
  description = "Security group ID for the ECS tasks"
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the ALB target group"
}
