variable "project" {
  type = string
}

variable "pubsub_notification_bucket_name" {
  description = "Name of the GCS bucket for PubSub notifications"
  type        = string
}
