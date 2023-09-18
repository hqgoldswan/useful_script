#!/bin/bash

# You can run the script with the URL and the target folder as arguments like this: ./scriptname.sh http://example.com/directory /path/to/target/folder

# Check if URL and target folder are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <URL> <Target Folder>"
    exit 1
fi

TARGET_URL=$1  # Get URL from command line argument
TARGET_FOLDER=$2  # Get target folder from command line argument

# Create the target folder if it doesn't exist
mkdir -p $TARGET_FOLDER

# Function to download files
download_files() {
    local url=$1
    local folder=$2

    # Get list of all files and folders
    local items=$(curl -s $url | grep href | sed 's/.*href="//' | sed 's/".*//')

    for item in $items; do
        # If item ends with '/', it's a folder
        if [[ "$item" == */ ]]; then
            # Recursively download files from the sub-folder
            download_files "$url$item" "$folder/${item%/}"
        else
            # Download the file
            curl -s $url$item -o $folder/$item
        fi
    done
}

# Start the download
download_files $TARGET_URL $TARGET_FOLDER