variable "project_id" {
  description = "The GCP Project ID for Development environment"
  type        = string
}

variable "region" {
  description = "Primary region for project resources provisioning"
  type        = string
  default     = "us-central1"
}

variable "env_name" {
  description = "Label for the different environments (dev, tst, prd, etc)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "tst", "pre", "prd"], var.env_name)
    error_message = "The env_name variable must be one of: dev, tst, pre, prd."
  }
}

variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "db_instance_tier" {
  description = "The machine type for Cloud SQL"
  type        = string
  default     = "db-f1-micro" # Suitable for development, consider upgrading for production
}

variable "db_name" {
  description = "The name of the initial database"
  type        = string
}

variable "db_password" {
  description = "The password for the initial database user"
  type        = string
  sensitive   = true
}
