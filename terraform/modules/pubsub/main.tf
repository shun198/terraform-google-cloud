# https://cloud.google.com/functions/docs/tutorials/terraform-pubsub?hl=ja
resource "google_pubsub_topic" "pubsub" {
  name = "${var.project}-topic"
}

resource "google_pubsub_subscription" "cloud_run_subscription" {
  name  = "${var.project}-subscription"
  topic = google_pubsub_topic.pubsub.name
  push_config {
    push_endpoint = var.cloud_run_service_uri
    oidc_token {
      service_account_email = var.cloud_run_service_account_email
    }
    attributes = {
      x-goog-version = "v1"
    }
  }
  filter = null
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.pubsub_dlq.id
    max_delivery_attempts = 5
  }
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
    table                 = "${var.project}.${var.pubsub_history_dataset_id}.${var.pubsub_history_dlq_errors_table_id}"
    use_table_schema      = false
    use_topic_schema      = true
    write_metadata        = true
    service_account_email = var.bq_subscription_service_account_email
  }

  expiration_policy {
    ttl = ""
  }
  retry_policy {
    maximum_backoff = "30s"
    minimum_backoff = "5s"
  }
}

resource "google_pubsub_topic" "pubsub_bq_topic" {
  name = "${var.project}-bq-topic"
}

resource "google_pubsub_subscription" "bq_subscription" {
  name  = "shun198-bq-subscription"
  topic = google_pubsub_topic.pubsub_bq_topic.id

  bigquery_config {
    table                 = "${var.project}.${var.pubsub_history_dataset_id}.${var.bq_subscription_history_table_id}"
    use_table_schema      = false
    use_topic_schema      = false
    write_metadata        = true
    drop_unknown_fields   = true
    service_account_email = var.bq_subscription_service_account_email
  }
}

# GCS Notification to Pub/Sub
# https://cloud.google.com/storage/docs/pubsub-notifications?hl=ja
# https://cloud.google.com/storage/docs/reporting-changes?hl=ja
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_notification
resource "google_storage_notification" "pubsub_notification" {
  bucket             = var.pubsub_notification_bucket_name
  payload_format     = "JSON_API_V1"
  topic              = google_pubsub_topic.gcs_notification_topic.id
  event_types        = ["OBJECT_FINALIZE", "OBJECT_METADATA_UPDATE"]
  object_name_prefix = "tmp/"
  depends_on         = [google_pubsub_topic_iam_binding.pubsub_topic_binding]
}

data "google_storage_project_service_account" "gcs_account" {
}

resource "google_pubsub_topic_iam_binding" "pubsub_topic_binding" {
  topic      = google_pubsub_topic.gcs_notification_topic.name
  role       = "roles/pubsub.publisher"
  members    = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
  depends_on = [google_pubsub_topic.gcs_notification_topic]
}

resource "google_pubsub_topic" "gcs_notification_topic" {
  name = "${var.project}-gcs-notification-topic"
}

resource "google_pubsub_subscription" "gcs_notification_subscription" {
  name  = "${var.project}-gcs-notification-subscription"
  topic = google_pubsub_topic.gcs_notification_topic.name
}
