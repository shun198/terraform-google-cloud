variable "project" {
  type = string
}

variable "pubsub_notification_bucket_name" {
  description = "Name of the GCS bucket for PubSub notifications"
  type        = string
}

variable "cloud_run_service_uri" {
  type = string
}

variable "pubsub_history_dataset_id" {
  description = "The BigQuery dataset ID to create the transfer config in."
  type        = string
}

variable "pubsub_history_dlq_errors_table_id" {
  description = "The BigQuery table ID to create the dead-letter queue table."
  type        = string
}

variable "cloud_run_service_account_email" {
  type = string
}

variable "dlq_to_bq_service_account_email" {
  type = string
}
