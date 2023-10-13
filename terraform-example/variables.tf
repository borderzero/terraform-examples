variable "border0_token" {
  description = "Border0 Token"
  default     = ""
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

