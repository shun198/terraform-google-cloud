resource "google_firestore_database" "database" {
  project     = var.project
  name        = "(default)"
  location_id = "nam5"
  type        = "FIRESTORE_NATIVE"
}

resource "google_firestore_field" "expireAtTTL" {
  project    = var.project
  collection = "collection"
  database   = google_firestore_database.database.name
  field      = "expireAt"

  ttl_config {}
}
