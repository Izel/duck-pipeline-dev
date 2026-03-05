# This Terraform module sets up IAM resources for the data pipeline, including 
# service accounts and IAM roles necessary for the pipeline to function 
# properly. It ensures that the pipeline has the required permissions to access 
# Cloud SQL, Cloud Run, Artifact Registry, and other necessary services.

data "google_project" "project" {}

# Service Account for the Pipeline
resource "google_service_account" "pipeline_sa" {
  account_id   = var.account_id
  display_name = "Service Account for Duck Pipeline Container"
}

# Grant permission to connect to Cloud SQL
resource "google_project_iam_member" "sql_client" {
  for_each = toset([
    "roles/cloudsql.client",
    "roles/logging.logWriter",
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/artifactregistry.writer",
    "roles/artifactregistry.reader",
    "roles/artifactregistry.repoAdmin",
    "roles/logging.logWriter"

  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.pipeline_sa.email}"
}


# Grant the Cloud Build Service Agent the power to "impersonate" the Cloud Run SA
resource "google_project_iam_member" "cloudbuild_service_agent_user" {
  for_each = toset([
    "roles/iam.serviceAccountUser",
    "roles/secretmanager.secretAccessor"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}

resource "google_service_account" "cloudbuild_sa" {
  account_id   = "duck-builder-sa-${var.env_name}"
  display_name = "Custom Cloud Build Service Account"
}

# Allow Cloud Build to act as the pipeline service account
resource "google_project_iam_member" "cloudbuild_sa_roles" {
  for_each = toset([
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/artifactregistry.writer",
    "roles/artifactregistry.reader",
    "roles/artifactregistry.repoAdmin",
    "roles/logging.logWriter",
    "roles/cloudbuild.builds.builder"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# Service Account for Cloud Scheduler
resource "google_service_account" "scheduler_sa" {
  account_id   = "pipeline-scheduler-sa-${var.env_name}"
  display_name = "Cloud Scheduler Service Account"
}

resource "google_project_iam_member" "scheduler_sa_roles" {
  for_each = toset([
    "roles/iam.serviceAccountUser",
    "roles/run.invoker"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.scheduler_sa.email}"
}

