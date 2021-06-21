terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

resource "google_storage_bucket" "gcs_bucket" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = true
}