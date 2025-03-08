variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "force_destroy" {
  type    = bool
  default = true
}
