#!/bin/bash

# Check if a directory path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory-path>"
    exit 1
fi

# Change to the specified directory
cd "$1" || exit

echo "Changing titles of all MP3 files in directory $1"

# Loop through all mp3 files in the directory
for file in *.mp3; do
    # Extract the current title from the file's metadata
    current_title=$(id3v2 -l "$file" | grep 'TIT2' | cut -d ':' -f 2-)

    # Extract the filename without the extension
    filename=$(basename "$file" .mp3)

    # Combine them to form the new title
    new_title="${filename} - ${current_title}"

    echo "Update the file ${filename}.mp3 title metadata to $new_title"
    # Update the file's title metadata
    id3v2 --TIT2 "$new_title" "$file"
done
