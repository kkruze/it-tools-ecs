variable "project_name" {
  type        = string
  description = "The project name"
  default     = "it-tools"
}

variable "aws_region" {
  type        = string
  description = "The AWS region for the infrastructure"
  default     = "us-east-1"
}


variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  type        = string
  description = "CIDR block for public subnet A"
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  type        = string
  description = "CIDR block for public subnet B"
  default     = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
  type        = string
  description = "CIDR block for private subnet A"
  default     = "10.0.3.0/24"
}

variable "private_subnet_b_cidr" {
  type        = string
  description = "CIDR block for private subnet B"
  default     = "10.0.4.0/24"
}

variable "availability_zone_a" {
  type        = string
  description = "Availability zone A"
  default     = "us-east-1a"
}

variable "availability_zone_b" {
  type        = string
  description = "Availability zone B"
  default     = "us-east-1b"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag deployed to ECS"
}