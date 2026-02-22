output "pubsub_history_dataset_id" {
  description = "The ID of the Pub/Sub history BigQuery dataset"
  value       = google_bigquery_dataset.pubsub_history.dataset_id
}

output "dlq_errors_table_id" {
  description = "The ID of the DLQ errors table in the Pub/Sub history dataset"
  value       = google_bigquery_table.dlq_errors.table_id
}

output "pubsub_subscription_table_id" {
  description = "The ID of the Pub/Sub subscription history table in the Pub/Sub history dataset"
  value       = google_bigquery_table.bq_subscription_history.table_id
}