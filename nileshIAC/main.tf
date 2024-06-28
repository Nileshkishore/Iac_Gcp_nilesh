provider "google" {
  project = "nileshfirst"
  region  = "asia-south1"
}

resource "google_storage_bucket" "bucket" {
  name     = "mybygcptyc"
  location = "asia-south1"
  force_destroy = true
}
