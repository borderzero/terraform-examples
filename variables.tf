variable "BORDER0_TOKEN" {
  description = "Border0 Token"
  sensitive   = true
  # Override this with the token you want to use instead of the default
  default = null
}
variable "AWS_REGION" {
  description = "AWS Region"
  # Override this with the region you want to use instead of the default
  default = null
}
variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key"
  sensitive   = true
  # Override this with the access key you want to use instead of the default
  default = null
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Key"
  sensitive   = true
  # Override this with the secret key you want to use instead of the default
  default = null
}
