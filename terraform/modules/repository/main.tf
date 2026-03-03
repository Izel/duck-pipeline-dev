# This Terraform module creates an Artifact Registry repository and a 
# Cloud Build trigger that listens for pushes to the main branch of a 
# specified GitHub repository. When a push is detected, it triggers a 
# Cloud Build pipeline defined in a cloudbuild.yaml file.

resource "google_artifact_registry_repository" "pipeline_artifact_repo" {
  location      = var.region
  repository_id = var.artifact_name
  description   = var.artifact_description
  format        = var.artifact_format
  # Labels for cost tracking
  labels = {
    env = var.env_name
  }
}

resource "google_cloudbuild_trigger" "github_trigger" {
  name        = var.trigger_name
  location    = var.region
  description = "Trigger for pushing to main branch"

  github {
    owner = var.github_user
    name  = var.github_repo
    push {
      branch = "main" # Trigger only on pushes to the main branch
    }
  }

  # Build configuration
  filename = "cloudbuild.yaml"

  # Pass the variables needed by the YAML
  substitutions = {
    _REGION       = var.region
    _REPO_NAME    = var.github_repo
    _SERVICE_NAME = var.pipeline_service_name
    _COMMIT_SHA   = "latest"
  }

  # Ensure the service account has permission to run builds
  service_account = "projects/${var.project_id}/serviceAccounts/${var.cloudbuild_sa_email}"
}

