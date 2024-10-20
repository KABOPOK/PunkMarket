from minio import Minio


# Initialize MinIO client
bucket_name = "photos"
minio_client = Minio(
    'localhost:9000',  # MinIO endpoint
    access_key='minioadmin',  # Replace with your MinIO access key
    secret_key='minioadmin',  # Replace with your MinIO secret key
    secure=False  # Set to True if using HTTPS
)
def initialize_storage():

    # Create the bucket if it doesn't exist
    if not minio_client.bucket_exists(bucket_name):
        minio_client.make_bucket(bucket_name)