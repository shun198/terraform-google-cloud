output "scheduled_query_service_account_email" {
  value       = google_service_account.scheduled_query_service_account.email
  description = "The email of the service account for scheduled queries"
}

output "cloud_run_service_account_email" {
  value       = google_service_account.cloud_run_sa.email
  description = "The email of the service account for Cloud Run Service"
}

output "cloud_run_jobs_service_account_email" {
  value       = google_service_account.cloud_run_jobs_sa.email
  description = "The email of the service account for Cloud Run Jobs"
}

output "cloud_scheduler_service_account_email" {
  value       = google_service_account.cloud_scheduler_sa.email
  description = "The email of the service account for Cloud Scheduler"
}

output "bq_subscription_service_account_email" {
  value       = google_service_account.bq_subscription.email
  description = "The email of the service account for BQ Subscription"
}
