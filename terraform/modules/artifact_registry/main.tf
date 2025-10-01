# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository
resource "google_artifact_registry_repository" "app_artifact_repository" {
  cleanup_policy_dry_run = false
  description            = null
  format                 = "DOCKER"
  location               = var.region
  mode                   = "STANDARD_REPOSITORY"
  project                = var.project
  repository_id          = "app"
}

resource "google_artifact_registry_repository" "job_artifact_repository" {
  cleanup_policy_dry_run = false
  description            = null
  format                 = "DOCKER"
  location               = var.region
  mode                   = "STANDARD_REPOSITORY"
  project                = var.project
  repository_id          = "job"
}
