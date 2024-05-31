variable "border0_token" {
  description = "Border0 Token"
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

variable "prefix" {
  description = "Name prefix"
  default     = ""
}

locals {
  default_tags = {
    Origin    = var.prefix != "" ? var.prefix : "Border0-example"
    Terraform = "true"
  }
}

