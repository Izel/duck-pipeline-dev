variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "region" {
  description = "GCP region for the resources"
  type        = string
}

variable "env_name" {
  description = "The environment name for the project"
  type        = string
  validation {
    condition     = contains(["dev", "tst", "pre", "prd"], var.env_name)
    error_message = "The env_name variable must be one of: dev, tst, pre, prd."
  }
}
