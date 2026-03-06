# This Terraform module sets up IAM resources for the data pipeline, including 
# service accounts and IAM roles necessary for the pipeline to function 
# properly. It ensures that the pipeline has the required permissions to access 
# Cloud SQL, Cloud Run, Artifact Registry, and other necessary services.

data "google_project" "project" {
  project_id = var.project_id
}

# Service Account for the Pipeline (Cloud Run)
resource "google_service_account" "pipeline_sa" {
  account_id   = var.account_id
  display_name = "Service Account for Duck Pipeline Container"
}

# Custom Cloud Build Service Account (The Builder)
resource "google_service_account" "cloudbuild_sa" {
  account_id   = "duck-builder-sa-${var.env_name}"
  display_name = "Custom Cloud Build Service Account"
}

# Service Account for Cloud Scheduler
resource "google_service_account" "scheduler_sa" {
  account_id   = "pipeline-scheduler-sa-${var.env_name}"
  display_name = "Cloud Scheduler Service Account"
}

# --- PERMISSIONS ---

# SQL Network User for the SQL Robot (Crucial for Private IP)
resource "google_project_iam_member" "sql_network_user" {
  project = var.project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloud-sql.iam.gserviceaccount.com"
}

# Roles for the Builder SA
resource "google_project_iam_member" "cloudbuild_sa_roles" {
  for_each = toset([
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/artifactregistry.writer",
    "roles/cloudbuild.builds.builder",
    "roles/secretmanager.secretAccessor"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# This gives the Cloud Build Robot the permissions it needs to run
resource "google_project_iam_member" "cloudbuild_robot_roles" {
  project = var.project_id
  role    = "roles/cloudbuild.serviceAgent"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}

# Roles for the Pipeline/Run SA
resource "google_project_iam_member" "pipeline_sa_roles" {
  for_each = toset([
    "roles/cloudsql.client",
    "roles/logging.logWriter",
    "roles/artifactregistry.reader"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.pipeline_sa.email}"
}

# Roles for the Scheduler SA
resource "google_project_iam_member" "scheduler_sa_roles" {
  for_each = toset([
    "roles/run.invoker"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.scheduler_sa.email}"
}
