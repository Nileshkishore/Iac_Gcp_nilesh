import base64
import json
import os
from google.cloud import storage, bigquery
import pandas as pd
from io import StringIO

def hello_gcs(event, context):
    """Triggered from a message on a Cloud Pub/Sub topic.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """
    pubsub_message = base64.b64decode(event['data']).decode('utf-8')
    message_data = json.loads(pubsub_message)

    bucket_name = message_data['bucket']
    file_name = message_data['name']

    print(f'Received file: {file_name} in bucket: {bucket_name}')

    # Initialize the Google Cloud Storage client
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)

    # Download the CSV file as a string
    data = blob.download_as_string()
    df = pd.read_csv(StringIO(data.decode('utf-8')))

    # Initialize the BigQuery client
    bq_client = bigquery.Client()
    dataset_id = os.getenv("BQ_DATASET_ID")
    table_id = os.getenv("BQ_TABLE_ID")
    table_ref = bq_client.dataset(dataset_id).table(table_id)

    # Load the data into BigQuery
    job = bq_client.load_table_from_dataframe(df, table_ref)
    job.result()  # Wait for the job to complete

    print(f'Successfully loaded {file_name} into {dataset_id}.{table_id}')