terraform {
 backend "gcs" {
   bucket  = "backend_bucket-nilesh-nk"
   prefix  = "terraform/state"
 }
}

locals {
  confg = jsondecode(file("${path.module}/config/project.json"))
}

provider "google" {
  project = local.confg.project_id
  region  = local.confg.region
}
