module "border0_on-ramp" {
  source = "./on-ramp"

  # we pass the token to border0 provider
  border0_token = var.MY_BORDER0_TOKEN

  # Resource name prefix to be added
  name_prefix = "b0-on-ramp"
}
