resource "google_container_cluster" "cluster" {
  name                = "${var.project}-cluster"
  location            = var.region
  project             = var.project
  networking_mode     = "VPC_NATIVE"
  initial_node_count  = 1
  deletion_protection = false
  enable_autopilot    = false
  network             = "projects/${var.project}/global/networks/${var.vpc_name}"
  subnetwork          = "projects/${var.project}/regions/${var.region}/subnetworks/${var.subnet1_name}"
  node_locations      = ["us-central1-a", "us-central1-c", "us-central1-f"]
  node_version        = "1.33.4-gke.1350000"
  min_master_version  = "1.33.4-gke.1350000"
  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    tags         = ["gke-node"]
    disk_size_gb = 30
  }
}
