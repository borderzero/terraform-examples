terraform {
  required_version = ">= 0.14.0"
  required_providers {
    border0 = {
      source  = "borderzero/border0"
      version = ">= 2.0.7"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.1"
    }
  }
}

provider "border0" {
  # we use the token from the environment variable or the one provided in the variables file
  token = var.BORDER0_TF_TOKEN != null ? var.BORDER0_TF_TOKEN : null
}

output "everything" {
  value = {
    "Please run this CLI script"                           = "./runme.sh"
    "You can view your infrastructure in the Admin Portal" = "https://portal.border0.com/"
  }
}
