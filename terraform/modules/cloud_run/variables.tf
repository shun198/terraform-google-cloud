variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "expire_at_ttl_collection_name" {
  type = string
}

variable "app_artifact_repository_id" {
  type = string
}

variable "job_artifact_repository_id" {
  type = string
}

variable "google_pubsub_topic_name" {
  type = string
}

variable "cloud_run_jobs_service_account_email" {
  type = string
}

variable "cloud_run_service_account_email" {
  type = string
}

variable "google_pubsub_bq_subscription_topic_name" {
  type = string
}