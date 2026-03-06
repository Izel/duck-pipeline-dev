# This Terraform module creates an Artifact Registry repository and a 
# Cloud Build trigger that listens for pushes to the main branch of a 
# specified GitHub repository. When a push is detected, it triggers a 
# Cloud Build pipeline defined in a cloudbuild.yaml file.

resource "google_artifact_registry_repository" "pipeline_artifact_repo" {
  location      = var.region
  repository_id = var.artifact_repo_name
  description   = var.artifact_repo_description
  format        = var.artifact_repo_format

  # Labels for cost tracking
  labels = {
    env = var.env_name
  }
}

data "google_project" "project" {}
resource "google_cloudbuild_trigger" "github_trigger" {
  project  = var.project_id
  name     = var.trigger_name
  location = var.region

  github {
    owner = var.github_user # Use your actual GitHub username
    name  = var.github_repo # Use your actual repo name
    push {
      branch = "^master$"
    }
  }

  filename = "cloudbuild.yaml"

  # We are using the default Compute SA for now since it usually has the most permissions
  #service_account = var.cloudbuild_sa_email
  service_account = "projects/${var.project_id}/serviceAccounts/${var.cloudbuild_sa_email}"
  #service_account = "projects/duck-pipeline-202603/serviceAccounts/duck-builder-sa-dev@duck-pipeline-202603.iam.gserviceaccount.com"
}




