terraform {
  required_version = ">= 0.14.0"
  required_providers {
    aws = ">= 3.0.0"
    border0 = {
      source  = "borderzero/border0"
      version = ">= 1.0.1"
    }
  }
}

provider "aws" {
  # It's better to rely on AWS's built-in credential sourcing mechanisms,
  # Uncomment the below lines to use static credentials from variables.tf file
  # region     = var.MY_AWS_REGION
  # access_key = var.MY_AWS_ACCESS_KEY_ID
  # secret_key = var.MY_AWS_SECRET_ACCESS_KEY
}


provider "border0" {
token = var.MY_BORDER0_TOKEN
}


module "border0_terraform-example" {
  source = "./terraform-example"

  # we pass the token to border0 provider
  border0_token = var.MY_BORDER0_TOKEN

  # Resource name prefix to be added
  prefix = "border0-terraform-example"
}
