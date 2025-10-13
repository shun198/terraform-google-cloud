output "vpc_name" {
  value       = google_compute_network.test_vpc.name
  description = "The name of the VPC"
}

output "subnet_1_name" {
  value       = google_compute_subnetwork.test_subnet_1.name
  description = "The name of the subnet 1"
}

output "subnet_2_name" {
  value       = google_compute_subnetwork.test_subnet_2.name
  description = "The name of the subnet 2"
}
