resource "google_cloud_run_v2_service" "cloud_run_service" {
  name     = "${var.project}-cloud-run-service"
  location = var.region

  deletion_protection = false

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project}/${google_artifact_registry_repository.app_artifact_repository.repository_id}/cloud-run-service-app:latest"
      env {
        name  = "GCP_PROJECT"
        value = var.project
      }
      env {
        name  = "FIRESTORE_COLLECTION_NAME"
        value = var.collection
      }
      ports {
        container_port = 8080
      }
    }
  }
  depends_on = [
    google_artifact_registry_repository.app_artifact_repository,
  ]
}

resource "google_cloud_run_v2_job" "cloud_run_job" {
  name     = "${var.project}-cloud-run-job"
  location = var.region

  deletion_protection = false

  template {
    template {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project}/${google_artifact_registry_repository.job_artifact_repository.repository_id}/cloud-run-jobs:latest"
        env {
          name  = "GCP_PROJECT"
          value = var.project
        }
        env {
          name  = "PUBSUB_TOPIC"
          value = google_pubsub_topic.pubsub.name
        }
      }
      service_account = google_service_account.cloud_run_jobs_sa.email
    }
  }
}
