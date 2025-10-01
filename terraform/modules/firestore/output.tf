output "expire_at_ttl_collection_name" {
  description = "The name of the Firestore collection"
  value       = google_firestore_field.expireAtTTL.collection
}
