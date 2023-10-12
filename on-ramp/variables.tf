variable "border0_token" {
  description = "Border0 Token"
  default     = ""
}
variable "name_prefix" {
  description = "Name prefix"
  default     = ""
}


locals {
  default_tags = {
    Origin = "Border0_on-ramp"
    Terraform = "true"
  }
}

