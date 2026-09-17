variable "project_name" {
  type        = string
  description = "the project name"
}


variable "vpc_cidr" {
  type        = string
  description = "the vpc cidr"

}

variable "public_subnet_a_cidr" {
  type        = string
  description = "public subnet a cidr"

}


variable "public_subnet_b_cidr" {
  type        = string
  description = "public subnet b cidr"

}

variable "private_subnet_a_cidr" {
  type        = string
  description = "private subnet a cidr"

}

variable "private_subnet_b_cidr" {
  type        = string
  description = "private subnet b cidr"

}

variable "availability_zone_a" {
  type        = string
  description = "Availability zone A"

}

variable "availability_zone_b" {
  type        = string
  description = "Availability zone B"

}
