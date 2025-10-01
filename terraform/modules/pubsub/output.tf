output "google_pubsub_topic_name" {
  value       = google_pubsub_topic.pubsub.name
  description = "The name of the Pub/Sub topic"
}
