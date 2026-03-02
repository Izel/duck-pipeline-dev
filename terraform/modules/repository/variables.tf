variable "region" {
  type        = string
  description = "The region for the artifact registry repository."
}

variable "repo_name" {
  type        = string
  description = "The name of the artifact registry repository."
}

variable "repo_format" {
  type        = string
  description = "The format of the artifact registry repository (e.g., DOCKER, MAVEN, etc.)."
}

variable "repo_description" {
  type        = string
  description = "The description of the artifact registry repository."
}

variable "env_name" {
  type        = string
  description = "The environment name (e.g., dev, staging, prod) for labeling and naming resources."
}
