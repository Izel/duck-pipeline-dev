resource "google_cloud_scheduler_job" "daily_etl_run" {
  name             = var.job_name
  description      = var.job_description
  schedule         = var.job_schedule
  time_zone        = var.job_time_zone
  attempt_deadline = var.job_attempt_deadline

  http_target {
    http_method = "GET"
    uri         = "https://services.arcgis.com/89v7YI99SreL8M8T/arcgis/rest/services/DU_University_Chapters/FeatureServer/0/query/"

    oidc_token {
      service_account_email = var.service_account_email
      audience              = var.pipeline_service_uri
    }
  }
}
