#!/bin/bash

sleep_seconds=5

# Define S3 bucket and object key
s3_bucket="elonniu"
s3_object_key="files/colors.txt"

s3_file="s3://$s3_bucket/$s3_object_key"
# Define local file path
local_file="/opt/ml/code/extensions/sd-dynamic-prompts/wildcards/colors.txt"

# check local file exists
if [ ! -f "$local_file" ]; then
    # Download the S3 file and save it to the local file
    aws s3 cp "$s3_file" "$local_file"
    echo "--- $s3_file has been downloaded to $local_file"
    cat $local_file
    return 0
fi

# Get metadata of the S3 object
s3_metadata=$(aws s3api head-object --bucket "$s3_bucket" --key "$s3_object_key")

# Extract the ETag (MD5 hash) from the S3 metadata without " (double quotes)
s3_etag=$(echo "$s3_metadata" | jq -r '.ETag' | tr -d '"')

# Get the local file's MD5 hash
local_etag=$(md5sum "$local_file" | awk '{print $1}')

# Compare ETags to check if the files are the same
if [ "$s3_etag" == "$local_etag" ]; then
    echo "--- $s3_file and $local_file are the same: $local_etag, No need to download."
else
    echo "$s3_file ETag: $s3_etag"
    echo "$local_file ETag: $local_etag"
    aws s3 cp "$s3_file" "$local_file"
    echo "--- $s3_file has been updated and downloaded to $local_file"
fi

cat $local_file

sleep $sleep_seconds
