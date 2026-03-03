variable "project_id" {
  type        = string
  description = "The project ID for the artifact registry repository."
}
variable "region" {
  type        = string
  description = "The region for the artifact registry repository."
}
variable "env_name" {
  type        = string
  description = "The environment name (e.g., dev, staging, prod) for labeling and naming resources."
}
variable "service_account" {
  type        = string
  description = "The service account email to use for the artifact registry repository."
}

# Artifact Registry Repository configuration variables
variable "artifact_repo_name" {
  type        = string
  description = "The name of the artifact at the artifact registry repository."
}
variable "artifact_repo_format" {
  type        = string
  description = "The format of the artifact registry repository (e.g., DOCKER, MAVEN, etc.)."
}
variable "artifact_repo_description" {
  type        = string
  description = "The description of the artifact registry repository."
}
variable "artifact_name" {
  type        = string
  description = "The name of the artifact within the artifact registry repository."
}
variable "artifact_commit_sha" {
  type        = string
  description = "The commit SHA of the artifact within the artifact registry repository."
}


# Github trigger configuration variables
variable "trigger_name" {
  description = "Cloud Build trigger name to start the deployment."
  type        = string
}
variable "github_user" {
  description = "Github user name"
  type        = string
}
variable "github_repo" {
  description = "Github repository name"
  type        = string
}
variable "pipeline_service_name" {
  type        = string
  description = "The name of the Cloud Run service to deploy the pipeline to."
}

# Service Account for Cloud Build
variable "cloudbuild_sa_email" {
  description = "The email of the Cloud Build service account to use for the trigger"
  type        = string
}
