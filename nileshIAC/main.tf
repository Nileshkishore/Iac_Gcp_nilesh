# terraform {
#  backend "gcs" {
#    bucket  = "backend_bucket"
#    prefix  = "terraform/state"
#  }
# }

locals {
  confg = jsondecode(file("${path.module}/config/project.json"))
}

provider "google" {
  project = local.confg.project_id
  region  = local.confg.region
}

resource "google_storage_bucket" "bucket" {
  name     = "backend_bucket"
  location = "asia-south1"
  force_destroy = true
}
