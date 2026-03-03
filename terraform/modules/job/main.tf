resource "google_cloud_scheduler_job" "daily_etl_run" {
  name             = var.job_name
  description      = var.job_description
  schedule         = var.job_schedule
  time_zone        = var.job_time_zone
  attempt_deadline = var.job_attempt_deadline

  http_target {
    http_method = "GET"
    # Point this to your Cloud Run URL!
    uri = "https://duck-pipeline-service-dev-248136157540.us-central1.run.app"
    oidc_token {
      service_account_email = var.service_account_email
      # The audience must match the target service URL
      audience = "https://duck-pipeline-service-dev-248136157540.us-central1.run.app"
    }
  }
}
