# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "${var.project}-vpc-network"
  auto_create_subnetworks = false
  project                 = var.project
}

# Subnetwork
resource "google_compute_subnetwork" "private-subnetwork-01" {
  name                     = "${var.project}-subnetwork-01"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  project                  = var.project
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private-subnetwork-02" {
  name                     = "${var.project}-subnetwork-02"
  ip_cidr_range            = "10.0.1.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  project                  = var.project
  private_ip_google_access = true
}

# # Cloud NAT
# resource "google_compute_router" "nat_router" {
#   name    = "${var.project}-nat-router"
#   network = google_compute_network.vpc_network.id
#   region  = var.region
#   project = var.project
# }

# resource "google_compute_router_nat" "nat_config" {
#   name                               = "${var.project}-nat-config"
#   router                             = google_compute_router.nat_router.name
#   region                             = var.region
#   project                            = var.project
#   nat_ip_allocate_option             = "AUTO_ONLY"
#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
#   depends_on = [
#     google_compute_router.nat_router,
#   ]
# }
