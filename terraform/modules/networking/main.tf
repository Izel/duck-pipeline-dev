# This Terraform module sets up the networking infrastructure for the data 
#pipeline, including a VPC network, a subnet, and a VPC Access Connector for 
# private connectivity to Cloud Run services.

resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# Red para recursos y servicios (BDs, Cloud Run, etc.) que necesitan acceso privado a la VPC
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.vpc_name}-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc.id
  region        = var.region
}

resource "google_vpc_access_connector" "connector" {
  name          = "${var.vpc_name}-connector"
  region        = var.region
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.vpc.name
}

# Private IP range for Cloud SQL
resource "google_compute_global_address" "private_ip_address" {
  name          = "google-managed-services-${var.env_name}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id # Use the ID, to ensure the VPC exists first
}

# Private connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id # Use the ID, to ensure the VPC exists first
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  deletion_policy         = null
  depends_on = [
    google_compute_network.vpc,
    google_compute_global_address.private_ip_address
  ]
}
