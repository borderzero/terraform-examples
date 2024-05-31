variable "prefix" {
  description = "Name prefix"
  default     = ""
}

variable "access-email" {
  description = "E-mail address that should have access the Border0 resources"
  type        = string
  validation {
    condition = ( length(var.access-email) > 0 )
    error_message = "The access-email variable must not be empty and must reference an existing user email in your Border0 organization."
  }
}

variable "private_subnet_ids" {
  description = "The ID of the private subnets"
  type        = map(string)
}

variable "allow_all_vpc_id" {
  description = "The ID of the allow all VPC"
  type        = string
}

locals {
  connector-token-param-path = var.prefix != "" ? "/border0/${var.prefix}-connector-token" : "/border0/border0-example-connector-token"
}

data "aws_region" "current" {}
variable "default_tags" {}
