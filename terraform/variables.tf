variable "project" {
  type    = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "force_destroy" {
  type    = bool
  default = true
}

variable "dataset" {
  type    = string
  default = "practice_dataset"
}

variable "github_repo" {
  type    = string
  default = "terraform-google-cloud"
}

variable "project_number" {
  type    = string
}

variable "collection" {
  type    = string
  default = "collection"
}
