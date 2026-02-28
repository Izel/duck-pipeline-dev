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
}

# Postgres Instance
resource "google_sql_database_instance" "instance" {
  name             = "ducks-db-${var.env_name}"
  region           = var.region
  database_version = "POSTGRES_15"

  # Ensure the connection is ready before creating the DB
  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = var.db_instance_tier
    ip_configuration {
      ipv4_enabled    = false # Disables Public IP
      private_network = var.network_id
    }
  }
}

resource "google_sql_database" "database" {
  name     = "ducks_data"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "users" {
  name     = "pipeline_user"
  instance = google_sql_database_instance.instance.name
  password = var.db_password #  pass this from Secret Manager later
}
