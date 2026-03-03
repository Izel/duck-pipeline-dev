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

# # Allow Cloud Run service agent to read and download from Artifact Registry (for pulling base images)
# resource "google_project_iam_member" "cloud_run_service_agent_roles" {
#   for_each = toset([
#     "roles/artifactregistry.reader",
#   ])
#   project = var.project_id
#   role    = each.key
#   member  = "serviceAccount:service-${data.google_project.project.number}@serverless-robot-prod.iam.gserviceaccount.com"
# }


# # Allow Cloud Build to act as the pipeline service account
# resource "google_service_account_iam_member" "cloudbuild_as_sa" {
#   service_account_id = google_service_account.pipeline_sa.name
#   role               = "roles/iam.serviceAccountUser"
#   member             = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
# }

# # Allow Cloud Build service account to act as Cloud Run service account for deployment
# resource "google_project_iam_member" "cloudbuild_run_admin" {
#   project = var.project_id
#   role    = "roles/run.admin"
#   member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
# }

# # Allow Cloud Build service account to act as Cloud Run service account for deployment
# resource "google_project_iam_member" "cloudbuild_artifactregistry_writer" {
#   project = var.project_id
#   role    = "roles/artifactregistry.writer"
#   member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
# }


# Allow Cloud Build service agent to read from Artifact Registry (for pulling base images)
# resource "google_project_iam_member" "cloud_run_service_agent_reader" {
#   project = var.project_id
#   role    = "roles/artifactregistry.reader"
#   member  = "serviceAccount:service-${data.google_project.project.number}@serverless-robot-prod.iam.gserviceaccount.com"
# }
