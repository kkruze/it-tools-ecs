variable "project_name" {
  type        = string
  description = "The project name"
}

variable "alb_sg" {
  type        = string
  description = "The alb security group"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "The public subnet ids"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id"
}
