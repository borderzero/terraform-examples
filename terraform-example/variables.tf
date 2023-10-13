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

locals {
  default_tags = {
    Origin = var.prefix != "" ? var.prefix : "Border0-example"
    Terraform = "true"
  }
}

