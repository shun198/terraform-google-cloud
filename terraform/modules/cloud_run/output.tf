output "cloud_run_service_uri" {
  value       = google_cloud_run_v2_service.cloud_run_service.uri
  description = "The URI of the Cloud Run service"
}

output "cloud_run_job_location" {
  value       = google_cloud_run_v2_job.cloud_run_job.location
  description = "The location of the Cloud Run job"
}

output "cloud_run_job_name" {
  value       = google_cloud_run_v2_job.cloud_run_job.name
  description = "The name of the Cloud Run job"
}
