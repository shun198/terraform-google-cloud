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
