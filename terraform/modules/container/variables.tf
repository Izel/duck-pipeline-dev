variable "region" {
  type        = string
  description = "The region for the artifact registry repository."
}

variable "env_name" {
  type        = string
  description = "The environment name for the project"
  validation {
    condition     = contains(["dev", "tst", "pre", "prd"], var.env_name)
    error_message = "The env_name variable must be one of: dev, tst, pre, prd."
  }
}
