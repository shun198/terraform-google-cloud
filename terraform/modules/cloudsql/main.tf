# CloudSQL(PostgreSQL)
resource "google_sql_database_instance" "postgres_instance" {
  name                = "${var.project}-postgres"
  database_version    = "POSTGRES_17"
  region              = var.region
  project             = var.project
  deletion_protection = false
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.id
    }
    backup_configuration {
      enabled = false
    }
  }
  depends_on = [
    google_compute_network.vpc_network,
  ]
}
