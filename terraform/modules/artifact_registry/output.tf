output "app_artifact_repository_id" {
  value       = google_artifact_registry_repository.app_artifact_repository.repository_id
  description = "The ID of the app artifact repository"
}

output "job_artifact_repository_id" {
  value       = google_artifact_registry_repository.job_artifact_repository.repository_id
  description = "The ID of the job artifact repository"
}
