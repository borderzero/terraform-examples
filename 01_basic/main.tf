terraform {
  required_providers {
    border0 = {
      source  = "borderzero/border0"
      version = ">= 2.0.8"
    }
  }
}

provider "border0" {
  # we use the token from the environment variable or the one provided in the variables file
  token = var.BORDER0_TF_TOKEN != null ? var.BORDER0_TF_TOKEN : null
}

output "everything" {
  value = {
    "To start the connector using cli"  = "border0 connector start --config ${path.module}/border0.yaml"
    "You can view your connector here:" = "https://portal.border0.com/connector/${border0_connector.first-connector.id}"
  }
}
