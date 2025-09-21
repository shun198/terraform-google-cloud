# Google Container Engine (GKE) Cluster
resource "google_container_cluster" "primary" {
  name                     = "${var.project}-gke-cluster"
  location                 = var.region
  project                  = var.project
  networking_mode          = "VPC_NATIVE"
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
}
