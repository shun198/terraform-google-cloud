resource "google_cloud_run_service" "cloud-run" {
  autogenerate_revision_name = false
  location                   = var.region
  name                       = "${var.project}-practice-artifact-registry"
  project                    = var.project
  metadata {
    annotations = {}
    labels      = {}
    namespace   = var.project
  }
  template {
    metadata {
      labels = {
        "run.googleapis.com/startupProbeType" = "Default"
      }
      name      = null
      namespace = null
    }
    spec {
      container_concurrency = 80
      service_account_name  = null
      timeout_seconds       = 300
      containers {
        args    = []
        command = []
        image   = "gcr.io/cloudrun/placeholder"
        name    = "placeholder-1"
        ports {
          container_port = 8080
          name           = "http1"
          protocol       = null
        }
        resources {
          limits = {
            cpu    = "1000m"
            memory = "512Mi"
          }
          requests = {}
        }
        startup_probe {
          failure_threshold     = 1
          initial_delay_seconds = 0
          period_seconds        = 240
          timeout_seconds       = 240
          tcp_socket {
            port = 8080
          }
        }
      }
    }
  }
  traffic {
    latest_revision = true
    percent         = 100
    revision_name   = null
    tag             = null
  }
}
