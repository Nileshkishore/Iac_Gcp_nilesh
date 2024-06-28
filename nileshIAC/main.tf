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


module "common" {
  source = "./modules/common"
  project_id = local.config.project_id
  service_account_email = local.config.service_account_email
  roles =      local.config.roles
  region     = local.config.region
  vpc_name   = local.config.vpc_name
  subnet_name = local.config.subnet_name
  subnet_cidr_range = local.config.subnet_cidr_range
}
module "vendor"{
  source = "./modules/vendor"
  bucket_name = local.config.bucket_name
  region = local.config.region
  vendor_topic_name = local.config.vendor_topic
  bigQuery_dataset_id = local.config.bigQuery_dataset_id
  bigQuery_location = local.config.bigQuery_location
  bigQuery_table_id = local.config.bigQuery_table_id
  functionName = local.config.functionName
  function_entry_point = local.config.function_entry_point
  project_id = local.config.project_id
  function_source_file_name = local.config.function_source_file_name
}