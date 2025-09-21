# https://cloud.google.com/functions/docs/tutorials/terraform-pubsub?hl=ja
resource "google_pubsub_topic" "pubsub" {
  name = "${var.project}-topic"
}

resource "google_pubsub_subscription" "cloud_run_subscription" {
  name  = "${var.project}-subscription"
  topic = google_pubsub_topic.pubsub.name
  push_config {
    push_endpoint = google_cloud_run_v2_service.cloud_run_service.uri
    oidc_token {
      service_account_email = google_service_account.cloud_run_sa.email
    }
    attributes = {
      x-goog-version = "v1"
    }
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.pubsub_dlq.id
    max_delivery_attempts = 5
  }
  depends_on = [google_cloud_run_v2_service.cloud_run_service]
}

resource "google_pubsub_topic" "pubsub_dlq" {
  name = "${var.project}-dlq-topic"
}

resource "google_pubsub_subscription" "pubsub_dlq_subscription" {
  ack_deadline_seconds         = 600
  enable_exactly_once_delivery = false
  enable_message_ordering      = false
  filter                       = null
  labels                       = {}
  message_retention_duration   = "604800s"
  name                         = "${google_pubsub_topic.pubsub_dlq.name}-sub"
  project                      = var.project
  retain_acked_messages        = false
  topic                        = google_pubsub_topic.pubsub_dlq.id

  bigquery_config {
    drop_unknown_fields   = false
    table                 = "${var.project}.${google_bigquery_dataset.pubsub_history.dataset_id}.${google_bigquery_table.dlq_errors.table_id}"
    use_table_schema      = false
    use_topic_schema      = true
    write_metadata        = true
    service_account_email = google_service_account.dlq_to_bq_sa.email
  }

  expiration_policy {
    ttl = ""
  }
  retry_policy {
    maximum_backoff = "30s"
    minimum_backoff = "5s"
  }
  depends_on = [
    google_pubsub_topic.pubsub_dlq,
    google_bigquery_table.dlq_errors
  ]
}
