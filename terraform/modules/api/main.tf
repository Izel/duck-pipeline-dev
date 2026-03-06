# The list of APIs required for the project. This list can be extended as needed, 
# but should include at least the compute API for the VPC to function properly.
#
# Note: compute.googleapis.com is required for the VPC and should not be removed 

# terraform {
#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = ">= 5.0"
#     }
#     google-beta = {
#       source  = "hashicorp/google-beta"
#       version = ">= 5.0"
#     }
#   }
# }

variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "sqladmin.googleapis.com",
    "run.googleapis.com",
    "vpcaccess.googleapis.com",
    "servicenetworking.googleapis.com",
    "artifactregistry.googleapis.com",
    "iam.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

# 1. Foundational API (Compute)
resource "google_project_service" "compute_api" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

# 2. All other APIs (depend on Compute)
resource "google_project_service" "ducks_services" {
  for_each           = toset(var.gcp_service_list)
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
  depends_on         = [google_project_service.compute_api]
}

# 3. Force create the SQL Service Agent (Robot)
resource "google_project_service_identity" "sql_sa" {
  provider   = google-beta
  project    = var.project_id
  service    = "sqladmin.googleapis.com"
  depends_on = [google_project_service.ducks_services]
}

# 4. Force create the Cloud Build Service Agent (Robot)
resource "google_project_service_identity" "cloudbuild_sa" {
  provider   = google-beta
  project    = var.project_id
  service    = "cloudbuild.googleapis.com"
  depends_on = [google_project_service.ducks_services]
}

# 5. The "Wait" resource to let GCP backend sync
resource "time_sleep" "wait_for_apis" {
  depends_on = [
    google_project_service.compute_api,
    google_project_service.ducks_services,
    google_project_service_identity.sql_sa,
    google_project_service_identity.cloudbuild_sa
  ]
  create_duration = "60s"
}

output "apis_ready" {
  value = time_sleep.wait_for_apis.id
}
