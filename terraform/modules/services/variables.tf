variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "GCP region for the resources"
  type        = string
}

variable "pipeline_service_name" {
  description = "The name of the Ducks Pipeline Service"
  type        = string
}

variable "pipeline_sa_email" {
  description = "The email of the service account used by the pipeline"
  type        = string
}

variable "image_path" {
  description = "The path of the container within the image to deploy"
  type        = string
}

variable "db_instance_connection_name" {
  description = "The name of the database server instance"
  type        = string
}
variable "db_name" {
  description = "The name of the initial database"
  type        = string
}
variable "db_user" {
  description = "The user for the initial database"
  type        = string
}
variable "db_password" {
  description = "The password for the initial database user"
  type        = string
  sensitive   = true
}

variable "connector_id" {
  description = "The ID of the VPC connector for Cloud Run"
  type        = string
}
