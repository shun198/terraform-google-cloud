output "pubsub_history_dataset_id" {
  description = "The ID of the Pub/Sub history BigQuery dataset"
  value       = google_bigquery_dataset.pubsub_history.dataset_id
}
