resource "google_artifact_registry_repository" "pipeline_repo" {
  location      = var.region
  repository_id = "ducks-pipeline-repo"
  description   = "Docker repository for the ducks-pipeline images"
  format        = "DOCKER"

  # Optional: Adds labels for cost tracking
  labels = {
    env = var.env_name
  }
}
