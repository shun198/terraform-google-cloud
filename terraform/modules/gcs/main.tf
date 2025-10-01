resource "google_storage_bucket" "pubsub_notification_bucket" {
  name     = "${var.project}-pubsub-notification-bucket"
  location = "US"

  uniform_bucket_level_access = true

  lifecycle {
    prevent_destroy = false
  }

}
