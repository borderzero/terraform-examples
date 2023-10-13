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
  # region     = var.AWS_REGION
  # access_key = var.AWS_ACCESS_KEY_ID
  # secret_key = var.AWS_SECRET_ACCESS_KEY
}


provider "border0" {
  token = var.BORDER0_TOKEN
}


module "border0_terraform-example" {
  source = "./terraform-example"

  # we pass the token to border0 provider
  border0_token = var.BORDER0_TOKEN

  # Set this to your email address to allow access to the Border0 policy
  # If not set, the default org wide policy will be the main access controlling policy
  access-email  = "example-username@terraform-example-domain.com"

  # Resource name prefix to be added
  prefix = "border0-terraform-example"
}
