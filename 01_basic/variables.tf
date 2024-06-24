# variables.tf

variable "BORDER0_TOKEN" {
  description = "Border0 Token"
  sensitive   = true
  # Override this with the token you want to use instead of the default or set it in the environment
  default = null
}

