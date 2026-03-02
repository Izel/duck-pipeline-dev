variable "project_id" {
  description = "The GCP Project ID for Development environment"
  type        = string
}

variable "account_id" {
  description = "The service account ID for IAM resources"
  type        = string
}

variable "env_name" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

