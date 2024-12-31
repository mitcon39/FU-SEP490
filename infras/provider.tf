terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.14.1"
    }
  }
}

provider "google" {
  # Configuration options
  project = var.project_id
  region  = var.location
}
