resource "google_cloud_scheduler_job" "job_scheduler" {
  name        = "trigger-sample-job"
  region      = var.region
  description = "Trigger Cloud Run Job every 1 hour"
  schedule    = var.schedule
  time_zone   = "Asia/Tokyo"

  http_target {
    http_method = "POST"
    uri         = "https://${var.cloud_run_job_location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_number}/jobs/${var.cloud_run_job_name}:run"

    oauth_token {
      service_account_email = var.cloud_scheduler_service_account_email
    }
  }
}
