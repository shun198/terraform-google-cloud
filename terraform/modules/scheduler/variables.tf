variable "project_number" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "schedule" {
  description = "The schedule in cron format."
  type        = string
}

variable "cloud_run_job_location" {
  type = string
}

variable "cloud_run_job_name" {
  type = string
}

variable "cloud_scheduler_service_account_email" {
  type = string
}
