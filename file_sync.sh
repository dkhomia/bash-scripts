#!/bin/bash

# Function to copy new files by extension pattern
copy_new_files() {
    source_dir="$1"
    destination_dir="$2"
    extension="$3"

    # Check if source directory exists and is readable
    if [ ! -d "$source_dir" ] || [ ! -r "$source_dir" ]; then
        echo "Source directory does not exist or is not readable: $source_dir"
        return 1
    fi

    # Check if destination directory exists and is writable
    if [ ! -d "$destination_dir" ] || [ ! -w "$destination_dir" ]; then
        echo "Destination directory does not exist or is not writable: $destination_dir"
        return 1
    fi

    # Copy new files with the specified extension pattern
    copied_files=0
    skipped_files=0

    for file in "$source_dir"/*."$extension"; do
        filename=$(basename "$file")
        destination_file="$destination_dir/$filename"
        if [[ ! -f "$destination_file" ]]; then
            cp "$file" "$destination_dir"
            echo "Copied: $filename"
            ((copied_files++))
        else
            source_file_size=$(stat -c%s "$file")
            destination_file_size=$(stat -c%s "$destination_file")
            source_file_date=$(stat -c%Y "$file")
            destination_file_date=$(stat -c%Y "$destination_file")

            if [[ $source_file_size -ne $destination_file_size ]] || [[ $source_file_date -gt $destination_file_date ]]; then
                cp "$file" "$destination_dir"
                echo "Copied: $filename (size or date mismatch)"
                ((copied_files++))
            else
                echo "Skipped: $filename (already exists in destination directory)"
                ((skipped_files++))
            fi
        fi
    done

    echo "Copying complete"
    echo "Copied files: $copied_files"
    echo "Skipped files: $skipped_files"
    return 0
}

# Check if all command-line arguments are provided
if [ $# -ne 3 ]; then
   echo "Usage: ./script.sh <source_directory> <destination_directory> <extension_pattern>"
   exit 1
fi

# Assign command-line arguments to variables
source_directory="$1"
destination_directory="$2"
extension_pattern="$3"

# Call the copy_new_files function with the provided variables
copy_new_files "$source_directory" "$destination_directory" "$extension_pattern"
