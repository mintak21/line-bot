terraform {
  required_version = "0.13.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.42.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "3.42.0"
    }
  }
}
