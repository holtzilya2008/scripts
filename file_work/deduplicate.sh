#!/bin/bash

# Check if the input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Check if the input file exists
if [ ! -f "$1" ]; then
    echo "File not found: $1"
    exit 1
fi

input_file="$1"
backup_file="${input_file}.bkp"

# Create a backup of the original file
cp "$input_file" "$backup_file"

# Process the file to remove duplicate lines
awk '{
    if (a[$0]++ == 0) {
        print $0
    } else {
        print NR "|" $0 > "/dev/stderr"
    }
}' "$input_file" > "${input_file}.tmp" 2> "${input_file}.duplicates"

# Replace the original file with the deduplicated one
mv "${input_file}.tmp" "$input_file"

# Print information about removed duplicate lines
echo "Duplicate lines removed (line number | content):"
cat "${input_file}.duplicates"

# Clean up
rm "${input_file}.duplicates"
