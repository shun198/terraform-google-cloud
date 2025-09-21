resource "google_bigquery_data_transfer_config" "insert_coupon_usage_query" {
  data_refresh_window_days  = 0
  data_source_id            = "scheduled_query"
  destination_dataset_id    = null
  disabled                  = true
  display_name              = "insert_coupon_usage"
  location                  = "us"
  notification_pubsub_topic = null
  params = {
    query = templatefile("./shared/query/insert_coupon_usage.sql", {
      dataset = var.dataset
    })
  }
  project              = var.project
  schedule             = "every 5 minutes synchronized"
  service_account_name = google_service_account.scheduled_query_service_account.email
}

resource "google_bigquery_dataset" "pubsub_history" {
  dataset_id                  = "pubsub_history"
  location                    = "EU"
  default_table_expiration_ms = null
}

resource "google_bigquery_table" "dlq_errors" {
  clustering          = null
  dataset_id          = google_bigquery_dataset.pubsub_history.dataset_id
  deletion_protection = false
  description         = "Error logs for messages sent to the dead letter queue"
  expiration_time     = 0
  project             = var.project
  schema = jsonencode([{
    mode = "NULLABLE"
    name = "subscription_name"
    type = "STRING"
    }, {
    mode = "NULLABLE"
    name = "message_id"
    type = "STRING"
    }, {
    mode = "NULLABLE"
    name = "publish_time"
    type = "TIMESTAMP"
    }, {
    mode = "NULLABLE"
    name = "data"
    type = "STRING"
    }, {
    mode = "NULLABLE"
    name = "attributes"
    type = "STRING"
  }])
  table_id = "dlq_errors"
}
