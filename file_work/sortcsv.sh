#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <column_number> <csv_file>"
    exit 1
fi

column_number=$1
csv_file=$2
backup_file="${csv_file%.csv}.bkp"

# Check if the CSV file exists
if [ ! -f "$csv_file" ]; then
    echo "Error: File $csv_file not found."
    exit 2
fi

# Create a backup of the original CSV file
cp "$csv_file" "$backup_file"

# Sort the CSV file by the specified column, excluding the header line
header=$(head -n 1 "$csv_file")
tail -n +2 "$csv_file" | sort -t ',' -k "$column_number" -o "$csv_file"

# Add the header back to the sorted CSV file
sed -i "1i $header" "$csv_file"

echo "Sorting complete. A backup of the original file is saved as $backup_file."
