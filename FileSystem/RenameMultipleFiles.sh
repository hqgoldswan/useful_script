#!/bin/bash

# This script will prompt you for a folder path and a filename pattern when run. It will then rename all files in the specified directory, changing their names to "pattern1.ext", "pattern2.ext", "pattern3.ext", etc., where "pattern" is the string you entered, and "ext" is the original file extension.

# As before, please make sure to back up your files before running this script, as it will change the original filenames. Also, this script doesn't handle file name collisions, so it's best used in a directory where the target filenames don't already exist.

# To run this script, save it to a file (e.g., rename_files.sh), give it execute permissions with chmod +x rename_files.sh, and then run it with ./rename_files.sh.

# Ask for user input
echo "Please enter the target folder path:"
read folder
echo "Please enter the desired filename pattern:"
read pattern

# Initialize counter
counter=1

# Change to the target directory
cd "$folder"

# For each file in the current directory
for file in *; do
    # Rename the file to the pattern and counter value, preserving the file extension
    mv -- "$file" "$pattern$counter.${file##*.}"
    
    # Increment the counter
    ((counter++))
done
