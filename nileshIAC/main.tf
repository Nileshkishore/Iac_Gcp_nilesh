# terraform {
#  backend "gcs" {
#    bucket  = "BUCKET_NAME"
#    prefix  = "terraform/state"
#  }
# }

provider "google" {
  project = "nileshfirst"
  region  = "asia-south1"
}

resource "google_storage_bucket" "bucket" {
  name     = "backend_bucket"
  location = "asia-south1"
  force_destroy = true
}
