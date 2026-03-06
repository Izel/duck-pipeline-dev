# This Terraform module sets up the Cloud SQL database instance for the data 
# pipeline, including the database, user, and private connectivity to the VPC 
# network. 

# Postgres Instance server setup
resource "google_sql_database_instance" "instance" {
  name             = var.db_server_instance_name
  region           = var.region
  database_version = "POSTGRES_15"

  settings {
    tier = var.db_instance_tier
    ip_configuration {
      ipv4_enabled = false
      # This will now receive the full projects/.../global/networks/... path
      private_network = var.vpc_name
    }
  }
  deletion_protection = false
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
