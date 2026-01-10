#!/bin/bash

# Set up variables
CREDENTIALS_PATH="/credentials"
CREDENTIALS_FILE="credentials.json"
BUCKET_NAME="${BUCKET_NAME}"  # Using the environment variable
MOUNT_PATH="/data"

# Ensure credentials exist
if [[ ! -f "$CREDENTIALS_PATH/$CREDENTIALS_FILE" ]]; then
    echo "Error: Credentials file not found at $CREDENTIALS_PATH/$CREDENTIALS_FILE"
    exit 1
fi

# Share mount with host
mount --make-shared /data

# Mount the GCS bucket
/usr/bin/gcsfuse --key-file "$CREDENTIALS_PATH/$CREDENTIALS_FILE" "$BUCKET_NAME" "$MOUNT_PATH"

# Check if the mount was successful
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to mount bucket $BUCKET_NAME"
    exit 1
fi

echo "Bucket $BUCKET_NAME mounted successfully at $MOUNT_PATH"

# Keep the script running to prevent container exit
tail -f /dev/null
