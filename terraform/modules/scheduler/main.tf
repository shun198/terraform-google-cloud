resource "google_cloud_scheduler_job" "job_scheduler" {
  name        = "trigger-sample-job"
  region      = var.region
  description = "Trigger Cloud Run Job every 1 hour"
  schedule    = var.schedule
  time_zone   = "Asia/Tokyo"

  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.cloud_run_job.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_number}/jobs/${google_cloud_run_v2_job.cloud_run_job.name}:run"

    oauth_token {
      service_account_email = google_service_account.cloud_scheduler_sa.email
    }
  }
}
