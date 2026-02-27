terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_project" "current" {
  project_id = var.project_id
}

module "api" {
  source     = "../../modules/api"
  project_id = var.project_id
}

module "networking" {
  source     = "../../modules/networking"
  vpc_name   = "${var.vpc_name}-${var.env_name}"
  region     = var.region
  depends_on = [module.api]
}


