output "network_id" {
  description = "The ID of the VPC being created"
  value       = google_compute_network.vpc.id
}

output "connector_id" {
  description = "The ID of the VPC Access Connector"
  value       = google_vpc_access_connector.connector.id
}
