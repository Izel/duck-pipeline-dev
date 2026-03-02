# Service Account for the Pipeline
resource "google_service_account" "pipeline_sa" {
  account_id   = var.account_id
  display_name = "Service Account for Ducks Pipeline Container"
}

# Grant permission to connect to Cloud SQL
resource "google_project_iam_member" "sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.pipeline_sa.email}"
}

data "google_project" "project" {}

# Allow Cloud Build to act as the pipeline service account
resource "google_service_account_iam_member" "cloudbuild_as_sa" {
  service_account_id = google_service_account.pipeline_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# Allow Cloud Build to manage Cloud Run
resource "google_project_iam_member" "cloudbuild_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
