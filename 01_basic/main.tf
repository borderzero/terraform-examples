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
    "To start the connector"            = "./runme.sh start"
    "You can see your sockets here:"    = "https://portal.border0.com/sockets"
    "You can view your Connector here:" = "https://portal.border0.com/connector/${border0_connector.first-connector.id}"
  }
}
