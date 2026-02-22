resource "google_cloud_run_v2_service" "cloud_run_service" {
  name     = "${var.project}-cloud-run-service"
  location = var.region

  deletion_protection = false

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project}/${var.app_artifact_repository_id}/cloud-run-service-app:latest"
      env {
        name  = "GCP_PROJECT"
        value = var.project
      }
      env {
        name  = "FIRESTORE_COLLECTION_NAME"
        value = var.expire_at_ttl_collection_name
      }
      ports {
        container_port = 8080
      }
    }
    service_account = var.cloud_run_jobs_service_account_email
  }
}

resource "google_cloud_run_v2_job" "cloud_run_job" {
  name     = "${var.project}-cloud-run-job"
  location = var.region

  deletion_protection = false

  template {
    template {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project}/${var.job_artifact_repository_id}/cloud-run-jobs:latest"
        env {
          name  = "GCP_PROJECT"
          value = var.project
        }
        env {
          name  = "PUBSUB_TOPIC"
          value = var.google_pubsub_topic_name
        }
      }
      service_account = var.cloud_run_jobs_service_account_email
    }
  }
}
