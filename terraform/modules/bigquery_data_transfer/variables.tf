variable "project" {
  type = string
}

variable "dataset" {
  description = "The BigQuery dataset ID to create the transfer config in."
  type        = string
}

variable "scheduled_query_service_account_email" {
  type = string
}
