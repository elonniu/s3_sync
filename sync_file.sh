#!/bin/bash

echo "-------------- sync_file.sh --------------"

# Define S3 bucket and object key
s3_bucket="elonniu"
s3_object_key="files/logo.jpg"

# Define local file path
local_file="/tmp/logo.jpg"

# check local file exists
if [ ! -f "$local_file" ]; then
    # Download the S3 file and save it to the local file
    aws s3 cp "s3://$s3_bucket/$s3_object_key" "$local_file"
    echo "S3 file has been downloaded to $local_file."
    return 0
fi

# Get metadata of the S3 object
s3_metadata=$(aws s3api head-object --bucket "$s3_bucket" --key "$s3_object_key")

# Extract the ETag (MD5 hash) from the S3 metadata
s3_etag=$(echo "$s3_metadata" | jq -r '.ETag')
echo "S3 ETag: $s3_etag"

# Get the local file's MD5 hash
local_etag=$(md5sum "$local_file" | awk '{print $1}')
echo "Local ETag: $local_etag"

# Compare ETags to check if the files are the same
if [ "$s3_etag" -eq "$local_etag" ]; then
    echo "S3 file and local file are the same. No need to download."
    return 0
fi

aws s3 cp "s3://$s3_bucket/$s3_object_key" "$local_file"
echo "S3 file has been updated and downloaded to $local_file."
