# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository
resource "google_artifact_registry_repository" "artifactory_repository" {
  location      = var.region
  repository_id = "${var.project}-${var.env}-artifactory-repository"
  format        = "DOCKER"
}
