resource "google_pubsub_topic" "pubsub" {
  name = "${var.project}-${var.env}-topic"
}
