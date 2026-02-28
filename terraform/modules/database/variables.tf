variable "project_id" {
  type        = string
  description = "The GCP Project ID for Development environment"
}

variable "region" {
  type        = string
  description = "Primary region for project resources provisioning"
}

variable "env_name" {
  type        = string
  description = "The environment name for the project"
  validation {
    condition     = contains(["dev", "tst", "pre", "prd"], var.env_name)
    error_message = "The env_name variable must be one of: dev, tst, pre, prd."
  }
}

variable "network_id" {
  type        = string
  description = "The network ID for the project"
}

variable "db_instance_tier" {
  description = "The machine type for Cloud SQL"
  type        = string
  default     = "db-f1-micro"
}

variable "db_password" {
  type      = string
  sensitive = true # Temporal while we set up the infrastructure.
}
