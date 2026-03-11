terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "7.23.0"
    }
  }

  backend "gcs" {
    bucket = "my-tf-state-bucket"
    prefix = "terraform/state"
  }
}

provider "google" {
  # Configuration options
}