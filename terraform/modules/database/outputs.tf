output "instance_connection_name" {
  description = "The instance connection name for the database"
  value       = google_sql_database_instance.instance.connection_name
}
