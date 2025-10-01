variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
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
