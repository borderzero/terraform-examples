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
  region     = var.AWS_REGION != null ? var.AWS_REGION : null
  access_key = var.AWS_ACCESS_KEY_ID != null ? var.AWS_ACCESS_KEY_ID : null
  secret_key = var.AWS_SECRET_ACCESS_KEY != null ? var.AWS_SECRET_ACCESS_KEY : null
}

provider "border0" {
  token = var.BORDER0_TOKEN != null ? var.BORDER0_TOKEN : null
}


module "border0_terraform-example" {
  source = "./terraform-example"

  # Set this to your email address to allow access to the Border0 policy
  # If not set, the default org wide policy will be the main access controlling policy
  access-email = "example-username@terraform-example-domain.com"

  # Resource name prefix to be added
  prefix = "border0-terraform-example"
}
