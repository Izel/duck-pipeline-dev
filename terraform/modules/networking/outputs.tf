output "vpc_name" {
  description = "The name of the VPC being created"
  value       = google_compute_network.vpc.name
}

output "connector_id" {
  description = "The ID of the VPC Access Connector"
  value       = google_vpc_access_connector.connector.id
}

output "vpc_id" {
  value = google_compute_network.vpc.id
}
