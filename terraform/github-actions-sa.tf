resource "google_service_account" "github_actions_sa" {
  account_id   = "github-actions-sa"
  disabled     = false
  display_name = "GitHub Actions Service Account"
  project      = var.project
}

resource "google_iam_workload_identity_pool" "github-actions-cicd-widp" {
  description               = null
  disabled                  = false
  display_name              = "github-actions-cicd"
  project                   = var.project_number
  workload_identity_pool_id = "github-actions-cicd"
}

resource "google_iam_workload_identity_pool_provider" "github-actions-cicd-widprovider" {
  attribute_condition = "assertion.repository == \"shun198/terraform-google-cloud\""
  attribute_mapping = {
    "google.subject" = "assertion.repository"
  }
  description                        = null
  disabled                           = false
  display_name                       = "GitHub"
  project                            = var.project_number
  workload_identity_pool_id          = "github-actions-cicd"
  workload_identity_pool_provider_id = "github"
  oidc {
    allowed_audiences = []
    issuer_uri        = "https://token.actions.githubusercontent.com"
    jwks_json         = null
  }
  depends_on = [
    google_iam_workload_identity_pool.github-actions-cicd-widp
  ]
}

resource "google_project_iam_member" "github_actions_sa_role_binding" {
  project = var.project
  role    = "roles/admin"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

resource "google_service_account_iam_member" "github_actions_sa" {
  service_account_id = google_service_account.github_actions_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/github-actions-cicd/attribute.repository/shun198/terraform-google-cloud"
}
