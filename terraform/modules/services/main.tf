resource "google_cloud_run_v2_service" "pipeline_service" {
  name     = var.pipeline_service_name
  location = var.region

  template {
    service_account = var.pipeline_sa_email
    containers {
      #image = "us-docker.pkg.dev/cloudrun/container/hello"
      image = var.image_path

      # Environment variables for database connection in container
      env {
        name  = "DB_USER"
        value = var.db_user
      }
      env {
        name  = "DB_PASSWORD"
        value = var.db_password
      }
      env {
        name  = "DB_NAME"
        value = var.db_name
      }
      env {
        name  = "INSTANCE_CONNECTION_NAME"
        value = var.db_instance_connection_name
      }
    }
    # Link to VPC Connector
    vpc_access {
      connector = var.connector_id
      egress    = "PRIVATE_RANGES_ONLY"
    }
  }
}
