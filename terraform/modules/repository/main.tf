resource "google_artifact_registry_repository" "pipeline_repo" {
  location      = var.region
  repository_id = var.repo_name
  description   = var.repo_description
  format        = var.repo_format
  # Labels for cost tracking
  labels = {
    env = var.env_name
  }
}
