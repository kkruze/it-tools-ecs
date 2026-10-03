variable "domain_name" {
  type        = string
  description = "Domain name for the ACM certificate"
}

variable "zone_id" {
  type        = string
  description = "Route 53 hosted zone ID for DNS validation"
}

variable "project_name" {
  type        = string
  description = "AWS project name"
}
