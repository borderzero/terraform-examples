variable "MY_AWS_REGION" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}
variable "MY_AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key"
  sensitive   = true
  type        = string
  default     = "A...6"
}

variable "MY_AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Key"
  sensitive   = true
  type        = string
  default     = "E...5"
}

variable "MY_BORDER0_TOKEN" {
  description = "Border0 Token"
  sensitive   = true
  type        = string
  default     = "ey...Bs"
}
