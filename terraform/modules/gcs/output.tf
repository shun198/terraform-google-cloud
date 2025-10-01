output "pubsub_notification_bucket_name" {
  value       = google_storage_bucket.pubsub_notification_bucket.name
  description = "The name of the Pub/Sub notification bucket"
}
