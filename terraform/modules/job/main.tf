# This Terraform module defines a Cloud Scheduler job that triggers the data pipeline

resource "google_cloud_scheduler_job" "daily_etl_run" {
  name             = var.job_name
  description      = var.job_description
  schedule         = var.job_schedule
  time_zone        = var.job_time_zone
  attempt_deadline = var.job_attempt_deadline

  http_target {
    http_method = "GET"
    uri         = var.pipeline_service_uri
    oidc_token {
      service_account_email = var.job_sa_email
      # The audience must match the target service URL
      audience = var.pipeline_service_uri
    }
  }
}
