# Private IP range for Cloud SQL
resource "google_compute_global_address" "private_ip_address" {
  name          = "google-managed-services-${var.env_name}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network_id
}

# Private connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  deletion_policy         = "ABANDON"
}

# Postgres Instance server setup
resource "google_sql_database_instance" "instance" {
  name             = var.db_server_instance_name
  region           = var.region
  database_version = "POSTGRES_15"
  settings {
    tier = var.db_instance_tier
    ip_configuration {
      ipv4_enabled    = false # Disables Public IP
      private_network = var.network_id
    }
  }
  deletion_protection = false
  depends_on          = [google_service_networking_connection.private_vpc_connection]
}

# Database setup
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
}

# Database user setup
resource "google_sql_user" "users" {
  name     = var.db_user
  instance = google_sql_database_instance.instance.name
  password = var.db_password #  This should be passed via Secret Manager
}
