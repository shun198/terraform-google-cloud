resource "google_storage_bucket" "tfstate" {
  name     = "${var.project}-tfstate"
  location = var.region

  force_destroy               = var.force_destroy
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  # オブジェクトのバージョニングを有効にする
  versioning {
    enabled = true
  }
}
