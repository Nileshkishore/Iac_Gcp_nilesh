
resource "google_storage_bucket" "bucket" {
  name     = var.bucket_name
  location = var.region
  force_destroy = true
}
 #Google Cloud Pub/Sub Topic
resource "google_pubsub_topic" "vendor_topic" {
  name = var.vendor_topic_name
}


#
# Google Storage Notification
resource "google_storage_notification" "notification" {
  bucket         = google_storage_bucket.bucket.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.vendor_topic.name
  event_types    = ["OBJECT_FINALIZE", "OBJECT_METADATA_UPDATE"]
  custom_attributes = {
    new-attribute = "new-attribute-value"
  }
}

resource "google_bigquery_dataset" "dataset" {
    dataset_id                  = var.bigQuery_dataset_id
    location                    =  var.bigQuery_location
  }

  # Google BigQuery Table.
  resource "google_bigquery_table" "table" {
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    table_id            = var.bigQuery_table_id
    deletion_protection = false
  }
  resource "google_cloudfunctions_function" "function" {
  name        = var.functionName
  description = "Triggered when a new CSV file is added to the bucket"
  runtime     = "python310"  # Specify the runtime, for example, Python 3.10

  entry_point = var.function_entry_point

  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.function_source.name

  environment_variables = {
    PROJECT_ID      = var.project_id
    BUCKET_NAME     = var.bucket_name
    BQ_DATASET_ID   = google_bigquery_dataset.dataset.dataset_id
    BQ_TABLE_ID     = google_bigquery_table.table.table_id
  }

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.vendor_topic.name
  }
}
resource "google_storage_bucket_object" "function_source" {
  name   = var.function_source_file_name
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.function_zip.output_path
}
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/cloudFunction"
  output_path = "${path.module}/cloudFunction/function.zip"
}