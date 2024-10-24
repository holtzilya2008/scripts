#!/bin/bash

# Script: trim_and_split_mp3.sh
# Description: This script iterates over all mp3 files in the current directory,
# runs the trim_silence.sh script to trim each file, and then runs split_large_media.sh
# to split the trimmed file into smaller pieces.

# Check if trim_silence.sh exists and is executable
if [ ! -x "./trim_silence.sh" ]; then
    echo "Error: trim_silence.sh is not found or not executable."
    exit 1
fi

# Check if split_large_media.sh exists and is executable
if [ ! -x "./split_large_media.sh" ]; then
    echo "Error: split_large_media.sh is not found or not executable."
    exit 1
fi

# Iterate over all mp3 files in the current directory
for input_file in *.mp3; do
    # Skip if no mp3 files are found
    if [ "$input_file" = "*.mp3" ]; then
        echo "No mp3 files found in the current directory."
        exit 0
    fi

    # Trim the mp3 file using trim_silence.sh
    echo "Processing file: $input_file"
    ./trim_silence.sh "$input_file"

    # Get the base name of the file (without the extension)
    base_name="${input_file%.*}"

    # Define the trimmed file name (output from trim_silence.sh)
    trimmed_file="${base_name}_tr.mp3"

    # Check if the trimmed file exists
    if [ -f "$trimmed_file" ]; then
        echo "Trimmed file $trimmed_file created successfully."

        # Split the trimmed file using split_large_media.sh
        ./split_large_media.sh "$trimmed_file"
    else
        echo "Trimmed file $trimmed_file was not created. Splitting Original file:"
        ./split_large_media.sh "$input_file"
    fi
done

echo "Script completed."
