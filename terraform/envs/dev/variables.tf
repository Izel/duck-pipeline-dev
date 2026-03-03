# Variables for Development Environment
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

# Container and service configuration variables
variable "pipeline_service_name" {
  description = "The name of the Ducks Pipeline Service"
  type        = string
}

# Database configuration Variables
variable "db_instance_tier" {
  description = "The machine type for Cloud SQL"
  type        = string
  default     = "db-f1-micro" # consider upgrading for production
}
variable "db_instance_name" {
  description = "The name of the database server instance"
  type        = string
}
variable "db_name" {
  description = "The name of the initial database"
  type        = string
}
variable "db_user" {
  description = "The user for the initial database"
  type        = string
}
variable "db_password" {
  description = "The password for the initial database user"
  type        = string
  sensitive   = true
}

# VPC configuration variable
variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
}

# Service Account for IAM resources
variable "account_id" {
  description = "The service account ID for IAM resources"
  type        = string
}

# Repository (Artifact Registry) configuration variables
variable "artifact_repo_name" {
  type        = string
  description = "The name of the artifact at the artifact registry repository."
}
variable "artifact_repo_format" {
  type        = string
  description = "The format of the artifact registry repository (e.g., DOCKER, MAVEN, etc.)."
}
variable "artifact_repo_description" {
  type        = string
  description = "The description of the artifact registry repository."
}
variable "artifact_name" {
  type        = string
  description = "The name of the artifact within the artifact registry repository."
}
variable "artifact_commit_sha" {
  type        = string
  description = "The commit SHA of the artifact within the artifact registry repository."
}

# Github trigger configuration variables
variable "trigger_name" {
  type        = string
  description = "The name of the Cloud Build trigger."
}
variable "github_user" {
  description = "Github user name"
  type        = string
}
variable "github_repo" {
  description = "Github repository name"
  type        = string
}

# Variables for Cloud Scheduler job
variable "job_name" {
  description = "The name of the Cloud Scheduler job"
  type        = string
  default     = "daily-ducks-etl-job"
}
variable "job_description" {
  description = "The description of the Cloud Scheduler job"
  type        = string
  default     = "Triggers the Ducks ETL pipeline daily"
}
variable "job_schedule" {
  description = "The schedule for the Cloud Scheduler job (cron format)"
  type        = string
  default     = "0 6 * * *" # Cron job runs at 6:00 AM every day
}
variable "job_time_zone" {
  description = "The time zone for the Cloud Scheduler job"
  type        = string
  default     = "America/New_York"
}
variable "job_attempt_deadline" {
  description = "The attempt deadline for the Cloud Scheduler job"
  type        = string
  default     = "320s"
}
