variable "border0_token" {
  description = "Border0 Token"
  default     = ""
}

variable "access-email" {
  description = "E-mail address that is allowd to access the Border0 resources"
  type        = string
}

variable "prefix" {
  description = "Name prefix"
  default     = ""
}

variable "private_subnet_ids" {
  description = "The ID of the private subnets"
  type = map(string)
}

variable "allow_all_vpc_id" {
  description = "The ID of the allow all VPC"
  type        = string
}

variable "smm-border0-token-path" {
  type = string
  description = "SSM parameter for the Border0 token"
  default     = "/border0/connector-token"
}

data "aws_region" "current" {}
variable "default_tags" {}
