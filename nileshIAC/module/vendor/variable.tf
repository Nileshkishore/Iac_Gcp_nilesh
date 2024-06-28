variable "bucket_name" {
    description = "bucket for cloud fucntion triggered"
  
}
variable "region" {
    description = "bucket region for cloud fucntion triggered"
  
}
variable "vendor_topic_name" {
    description = "name of pusub"
  
}
variable "bigQuery_dataset_id" {
    description = "name of big query database"
  
}
variable "bigQuery_location" {
    description = "location of bigquery"
  
}
variable "bigQuery_table_id" {
    description = "tablr name of bigquery where data will dump"
  
}
variable "functionName" {
    description = "triggered function name"
  
}
variable "function_entry_point" {
    description = "entry point of function name"
  
}
variable "project_id" {
  description = "The GCP project ID"
 
}
variable "function_source_file_name" {
    description = "name of source file "
}