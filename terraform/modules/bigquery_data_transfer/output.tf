output "insert_coupon_user_history_scheduled_query_id" {
  value       = google_bigquery_data_transfer_config.insert_coupon_usage_query.id
  description = "The ID of the scheduled query to insert coupon usage"
}
