#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: ./remove_csv_col.sh <column_number> <csv_file>"
  exit 1
fi

# Check if the provided file exists
if [ ! -f "$2" ]; then
  echo "Error: File '$2' not found"
  exit 1
fi

column_number=$1
csv_file=$2
backup_file="${csv_file}.bkp"

# Create a backup of the original file
cp "$csv_file" "$backup_file"

# Remove the specified column from the CSV file
awk -F, -v col="$column_number" '{
  for (i=1; i<=NF; i++) {
    if (i != col) {
      printf("%s%s", $i, (i==NF) ? "\n" : ",")
    }
  }
}' "$backup_file" > "$csv_file"
