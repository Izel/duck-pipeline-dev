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
variable "pipeline_service_name" {
  description = "The name of the Ducks Pipeline Service"
  type        = string
}
variable "pipeline_service_uri" {
  description = "The URI of the Ducks Pipeline Service"
  type        = string
}
variable "job_sa_email" {
  description = "The email of the service account for Cloud Scheduler to invoke the pipeline"
  type        = string
}
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

