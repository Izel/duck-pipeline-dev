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
  name        = var.trigger_name
  location    = "global"
  description = "Trigger for pushing to master branch"

  github {
    owner = var.github_user
    name  = var.github_repo
    push {
      branch = "^master$" # Trigger only on pushes to the master branch
    }
  }
  # Build configuration
  filename = "cloudbuild.yaml"

  # Pass the variables needed by the YAML
  substitutions = {
    _PROJECT_ID   = var.project_id
    _REGION       = var.region
    _REPO_NAME    = var.artifact_repo_name
    _SERVICE_NAME = var.pipeline_service_name
    _IMAGE_NAME   = var.artifact_name
    _COMMIT_SHA   = var.artifact_commit_sha
  }

  # Ensure the service account has permission to run builds
  service_account = "projects/${var.project_id}/serviceAccounts/${var.cloudbuild_sa_email}"
}

