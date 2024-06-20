variable "prefix" {
  description = "Name prefix"
  default     = ""
}


locals {
  rds-password-param-path = var.prefix != "" ? "/border0/${var.prefix}-rdsPass" : "/border0/border0-example-RDS-Pass"
  rds-username-param-path = var.prefix != "" ? "/border0/${var.prefix}-rdsUser" : "/border0/border0-example-RDS-User"
}

data "aws_region" "current" {}
variable "default_tags" {}
