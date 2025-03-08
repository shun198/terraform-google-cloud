resource "google_bigquery_data_transfer_config" "insert_coupon_usage_query" {
  data_refresh_window_days  = 0
  data_source_id            = "scheduled_query"
  destination_dataset_id    = null
  disabled                  = true
  display_name              = "insert_coupon_usage"
  location                  = "us"
  notification_pubsub_topic = null
  params = {
    query = templatefile("${path.module}/query/insert_coupon_usage.sql", {
      dataset = var.dataset
    })
  }
  project              = var.project
  schedule             = "every 15 minutes"
  service_account_name = null
}
