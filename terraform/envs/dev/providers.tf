terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

# Standard Provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Beta Provider configuration
provider "google-beta" {
  project = var.project_id
  region  = var.region
}
