resource "google_service_account" "scheduled_query_service_account" {
  account_id   = "scheduled-query-sa"
  display_name = "Scheduled Query Service Account"
}

resource "google_project_iam_member" "bq_transfer" {
  project = var.project
  role    = "roles/bigquerydatatransfer.serviceAgent"
  member  = "serviceAccount:${google_service_account.scheduled_query_service_account.email}"
}

resource "google_project_iam_member" "custom_bq_transfer" {
  project = var.project
  role    = google_project_iam_custom_role.custom_bigquery_transfer_role.name
  member  = "serviceAccount:${google_service_account.scheduled_query_service_account.email}"
}

resource "google_project_iam_custom_role" "custom_bigquery_transfer_role" {
  project     = var.project
  role_id     = "custom_BigQuery_Transfer_Role"
  title       = "Custom BigQuery Transfer Role"
  description = "Custom role with BigQuery Transfer permissions"
  permissions = [
    "bigquery.tables.getData",
    "bigquery.tables.updateData",
    "bigquery.transfers.get",
    "bigquery.transfers.update",
    "bigquery.jobs.create",
  ]
}

resource "google_service_account" "cloud_run_sa" {
  account_id   = "cloud-run-service-invoker"
  display_name = "Cloud Run Invoker"
}

resource "google_project_iam_member" "cloud_run_service_invoker" {
  project = var.project
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

resource "google_service_account" "cloud_run_jobs_sa" {
  account_id   = "cloud-run-jobs-invoker"
  display_name = "Cloud Run Jobs Invoker"
}

resource "google_project_iam_member" "cloud_run_jobs_invoker" {
  project = var.project
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.cloud_run_jobs_sa.email}"
}

resource "google_project_iam_member" "cloud_run_jobs_publisher" {
  project = var.project
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.cloud_run_jobs_sa.email}"
}

resource "google_service_account" "cloud_scheduler_sa" {
  account_id   = "cloud-scheduler-jobs-invoker"
  display_name = "Cloud Scheduler Jobs Invoker"
}

resource "google_project_iam_member" "cloud_scheduler_jobs_admin" {
  project = var.project
  role    = "roles/cloudscheduler.admin"
  member  = "serviceAccount:${google_service_account.cloud_scheduler_sa.email}"
}

resource "google_project_iam_member" "cloud_scheduler_jobs_invoker" {
  project = var.project
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.cloud_scheduler_sa.email}"
}

resource "google_service_account" "dlq_to_bq_sa" {
  account_id   = "dlq-to-bq-sa"
  display_name = "Service Account for DLQ to BigQuery push"
}
resource "google_project_iam_member" "bq_data_editor" {
  project = var.project
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.dlq_to_bq_sa.email}"
}

resource "google_project_iam_member" "pubsub_subscriber" {
  project = var.project
  role    = "roles/pubsub.editor"
  member  = "serviceAccount:${google_service_account.dlq_to_bq_sa.email}"
}

