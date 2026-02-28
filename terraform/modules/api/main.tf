
# -----------------------------------------------------------------------------
# 
# The list of APIs required for the project. This list can be extended as needed, 
# but should include at least the compute API for the VPC to function properly.
# Note: compute.googleapis.com is required for the VPC and should not be removed 
#       from the list
# -----------------------------------------------------------------------------

variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "compute.googleapis.com",           # Networking
    "sqladmin.googleapis.com",          # Cloud SQL
    "run.googleapis.com",               # Cloud Run
    "vpcaccess.googleapis.com",         # VPC Connector
    "servicenetworking.googleapis.com", # Required for private services access (Cloud SQL)
    "secretmanager.googleapis.com",     # For password management
    "artifactregistry.googleapis.com"   # For container image storage
  ]
}

resource "google_project_service" "ducks_services" {
  for_each           = toset(var.gcp_service_list)
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
  depends_on         = [google_project_service.compute_api]
}

resource "google_project_service" "compute_api" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}
