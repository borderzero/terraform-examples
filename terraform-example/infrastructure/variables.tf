variable "prefix" {
  description = "Name prefix"
  default     = ""
}

variable "smm-db-password-path" {
  type = string
  description = "SSM parameter for the RDS password"
  default     = "/border0/demo-rds-password"
}

variable "smm-db-username-path" {
  type = string
  description = "SSM parameter for the RDS username"
  default     = "/border0/demo-rds-username"
}

data "aws_region" "current" {}
variable "default_tags" {}
