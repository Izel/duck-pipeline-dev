data "google_project" "project" {}

# Service Account for the Pipeline
resource "google_service_account" "pipeline_sa" {
  account_id   = var.account_id
  display_name = "Service Account for Duck Pipeline Container"
}

# Grant permission to connect to Cloud SQL
resource "google_project_iam_member" "sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.pipeline_sa.email}"
}

# Allow Cloud Build to act as the pipeline service account
resource "google_project_iam_member" "pipeline_sa_roles" {
  for_each = toset([
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/artifactregistry.writer",
    "roles/artifactregistry.reader",
    "roles/artifactregistry.repoAdmin",
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
