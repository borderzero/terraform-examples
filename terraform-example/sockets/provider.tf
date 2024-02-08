terraform {
  required_version = ">= 0.14.0"
  required_providers {
    aws = ">= 3.0.0"
    border0 = {
      source  = "borderzero/border0"
      version = ">= 2.0.0"
    }
  }
}

