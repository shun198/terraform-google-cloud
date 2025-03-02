variable "project" {
  type = string
}

variable "env" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "force_destroy" {
  type    = bool
  default = false
}
