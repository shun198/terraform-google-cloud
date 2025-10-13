# https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build
terraform {
  required_version = ">= 1.11.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

module "artifact_registry" {
  source  = "../../modules/artifact_registry"
  project = var.project
  region  = var.region
}

module "bigquery" {
  source  = "../../modules/bigquery"
  project = var.project
}

module "bigquery_data_transfer" {
  source                                = "../../modules/bigquery_data_transfer"
  project                               = var.project
  dataset                               = module.bigquery.pubsub_history_dataset_id
  scheduled_query_service_account_email = module.iam.scheduled_query_service_account_email
}

module "cloud_run" {
  source                               = "../../modules/cloud_run"
  project                              = var.project
  region                               = var.region
  expire_at_ttl_collection_name        = module.firestore.expire_at_ttl_collection_name
  app_artifact_repository_id           = module.artifact_registry.app_artifact_repository_id
  job_artifact_repository_id           = module.artifact_registry.job_artifact_repository_id
  google_pubsub_topic_name             = module.pubsub.google_pubsub_topic_name
  cloud_run_jobs_service_account_email = module.iam.cloud_run_jobs_service_account_email
}

module "firestore" {
  source  = "../../modules/firestore"
  project = var.project
}

module "gcs" {
  source  = "../../modules/gcs"
  project = var.project
}

module "gke" {
  source       = "../../modules/gke"
  project      = var.project
  region       = var.region
  vpc_name     = module.vpc.vpc_name
  subnet1_name = module.vpc.subnet_1_name
  subnet2_name = module.vpc.subnet_2_name
}

module "iam" {
  source         = "../../modules/iam"
  project        = var.project
  project_number = var.project_number
}

module "monitoring" {
  source                                        = "../../modules/monitoring"
  project                                       = var.project
  insert_coupon_user_history_scheduled_query_id = module.bigquery_data_transfer.insert_coupon_user_history_scheduled_query_id
}

module "pubsub" {
  source                             = "../../modules/pubsub"
  project                            = var.project
  pubsub_notification_bucket_name    = module.gcs.pubsub_notification_bucket_name
  cloud_run_service_uri              = module.cloud_run.cloud_run_service_uri
  pubsub_history_dataset_id          = module.bigquery.pubsub_history_dataset_id
  pubsub_history_dlq_errors_table_id = module.bigquery.dlq_errors_table_id
  cloud_run_service_account_email    = module.iam.cloud_run_service_account_email
  dlq_to_bq_service_account_email    = module.iam.dlq_to_bq_service_account_email
}

module "scheduler" {
  source                                = "../../modules/scheduler"
  project_number                        = var.project_number
  region                                = var.region
  schedule                              = var.schedule
  cloud_run_job_location                = module.cloud_run.cloud_run_job_location
  cloud_run_job_name                    = module.cloud_run.cloud_run_job_name
  cloud_scheduler_service_account_email = module.iam.cloud_scheduler_service_account_email
}

module "vpc" {
  source  = "../../modules/vpc"
  project = var.project
}
