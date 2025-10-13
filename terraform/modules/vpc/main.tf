resource "google_compute_network" "test_vpc" {
  auto_create_subnetworks                   = false
  delete_default_routes_on_create           = false
  description                               = null
  enable_ula_internal_ipv6                  = false
  internal_ipv6_range                       = null
  mtu                                       = 1460
  name                                      = "test-vpc"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  project                                   = var.project
  routing_mode                              = "REGIONAL"
}

resource "google_compute_subnetwork" "test_subnet_1" {
  description                      = null
  external_ipv6_prefix             = null
  ip_cidr_range                    = "10.0.0.0/24"
  ipv6_access_type                 = null
  name                             = "test-subnet-1"
  network                          = "https://www.googleapis.com/compute/v1/projects/${var.project}/global/networks/${google_compute_network.test_vpc.name}"
  private_ip_google_access         = true
  private_ipv6_google_access       = "DISABLE_GOOGLE_ACCESS"
  project                          = var.project
  purpose                          = "PRIVATE"
  region                           = var.region
  reserved_internal_range          = null
  role                             = null
  send_secondary_ip_range_if_empty = null
  stack_type                       = "IPV4_ONLY"
}


resource "google_compute_subnetwork" "test_subnet_2" {
  description                      = null
  external_ipv6_prefix             = null
  ip_cidr_range                    = "10.0.1.0/24"
  ipv6_access_type                 = null
  name                             = "test-subnet-2"
  network                          = "https://www.googleapis.com/compute/v1/projects/${var.project}/global/networks/${google_compute_network.test_vpc.name}"
  private_ip_google_access         = true
  private_ipv6_google_access       = "DISABLE_GOOGLE_ACCESS"
  project                          = var.project
  purpose                          = "PRIVATE"
  region                           = var.region
  reserved_internal_range          = null
  role                             = null
  send_secondary_ip_range_if_empty = null
  stack_type                       = "IPV4_ONLY"
}
