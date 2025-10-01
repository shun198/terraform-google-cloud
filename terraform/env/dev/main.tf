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

module "pubsub" {
  source = "../../modules/pubsub"

  project                         = var.project
  pubsub_notification_bucket_name = module.gcs.pubsub_notification_bucket_name
}

module "gcs" {
  source  = "../../modules/gcs"
  project = var.project
}

module "artifact_registry" {
  source  = "../../modules/artifact_registry"
  project = var.project
  region  = var.region
}

# module "cloud_run" {
#   source = "../modules/cloud_run"

#   project      = var.project
#   region       = var.region
#   service_name = "request"
#   image        = "gcr.io/${var.project}/request:latest"
#   port         = 8080
#   env_vars = {
#     PROJECT          = var.project
#     REGION           = var.region
#     BIGQUERY_DATASET = var.bigquery_dataset
#     BIGQUERY_TABLE   = var.bigquery_table
#     PUBSUB_TOPIC     = var.pubsub_topic
#     GCP_CREDENTIALS  = var.gcp_credentials
#   }
# }

# module "bigquery" {
#   source = "../modules/bigquery"

#   project                         = var.project
#   dataset_name                    = var.bigquery_dataset
#   table_name                      = var.bigquery_table
#   table_schema                    = file("../modules/bigquery/schema.json")
#   location                        = var.region
#   pubsub_topic                    = var.pubsub_topic
#   gcp_credentials                 = var.gcp_credentials
# }

module "firestore" {
  source  = "../../modules/firestore"
  project = var.project
}

# module "scheduler" {
#   source = "../modules/scheduler"

#   project          = var.project
#   region           = var.region
#   time_zone        = "Asia/Tokyo"
#   pubsub_topic     = var.pubsub_topic
#   gcp_credentials  = var.gcp_credentials
#   bigquery_dataset = var.bigquery_dataset
#   bigquery_table   = var.bigquery_table
# }

# module "bigquery_data_transfer" {
#   source = "../modules/bigquery_data_transfer"

#   project        = var.project
#   dataset_name   = var.bigquery_dataset
#   display_name   = "insert-coupon-usage"
#   data_source_id = "scheduled_query"
#   schedule       = "every 24 hours"
#   params = {
#     destination_table_name_template = var.bigquery_table
#     write_disposition               = "WRITE_APPEND"
#     query                           = file("../modules/bigquery/insert_coupon_usage.sql")
#   }
#   location        = var.region
#   gcp_credentials = var.gcp_credentials
# }
