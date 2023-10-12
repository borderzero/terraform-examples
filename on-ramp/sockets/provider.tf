terraform {
  required_providers {
    border0 = {
      source  = "borderzero/border0"
    #   version = "1.0.1"
    }
  }
}

provider "border0" {
token = var.border0_token
}
