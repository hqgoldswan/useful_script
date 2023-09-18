#!/bin/bash

# Check if URL and target folder are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <URL> <Target Folder>"
    exit 1
fi

TARGET_URL=$1  # Get URL from command line argument
TARGET_FOLDER=$2  # Get target folder from command line argument

# Create the target folder if it doesn't exist
mkdir -p $TARGET_FOLDER

# Download files recursively
wget -r -np -nH --cut-dirs=3 -P $TARGET_FOLDER $TARGET_URL
