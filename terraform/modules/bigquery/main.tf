resource "google_bigquery_dataset" "pubsub_history" {
  dataset_id                  = "pubsub_history"
  location                    = "US"
  project                     = var.project
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

resource "google_bigquery_table" "bq_subscription_history" {
  clustering          = null
  dataset_id          = google_bigquery_dataset.pubsub_history.dataset_id
  deletion_protection = false
  description         = "History of messages sent to the subscription"
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
  table_id = "bq_subscription_history"
}