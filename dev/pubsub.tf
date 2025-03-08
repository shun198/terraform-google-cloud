# https://cloud.google.com/functions/docs/tutorials/terraform-pubsub?hl=ja
resource "google_pubsub_topic" "pubsub" {
  name = "${var.project}-topic"
}
