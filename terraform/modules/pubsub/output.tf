output "google_pubsub_topic_name" {
  value       = google_pubsub_topic.pubsub.name
  description = "The name of the Pub/Sub topic"
}

output "google_pubsub_bq_subscription_topic_name" {
  value       = google_pubsub_topic.pubsub_bq_topic.name
  description = "The name of the Pub/Sub topic for BigQuery subscription"
}