variable "BORDER0_TF_TOKEN" {
  description = "Border0 Service Account Token"
  sensitive   = true
  # Override this with the token you want to use instead of the default
  # alternatively export TF_VAR_BORDER0_TOKEN="ey...9Iw" environment variable
  default = null
}

