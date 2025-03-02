terraform {
  backend "gcs" {
    bucket = "${var.project}-${var.env}-tfstate"
    prefix = "terraform/state"
  }
}
