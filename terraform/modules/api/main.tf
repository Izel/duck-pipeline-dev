# The list of APIs your ducks-pipeline needs
variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "compute.googleapis.com",   # Networking
    "sqladmin.googleapis.com",  # Cloud SQL
    "run.googleapis.com",       # Cloud Run
    "vpcaccess.googleapis.com", # VPC Connector
    "secretmanager.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
}

resource "google_project_service" "ducks_services" {
  for_each           = toset(var.gcp_service_list)
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}
