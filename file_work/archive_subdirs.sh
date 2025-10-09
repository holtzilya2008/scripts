#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Usage: $0 [-gz] <path>"
  exit 1
fi

# Check if the optional -gz flag is provided
if [ "$1" == "-gz" ]; then
  compress_gz=true
  shift
else
  compress_gz=false
fi

path="$1"

if [ ! -d "$path" ]; then
  echo "Error: $path is not a valid directory"
  exit 1
fi

echo "Loop through the subdirectories and create tar or tar.gz files"
for subdir in "$path"/*/; do
  if [ -d "$subdir" ]; then
    base_name="$(basename "$subdir")"
    echo "Working on $base_name"
    if $compress_gz; then
      tar -I 'gzip -9' -cvf "$path/$base_name.tar.gz" -C "$path" "$base_name"
    else
      tar -cvf "$path/$base_name.tar" -C "$path" "$base_name"
    fi
  fi
done

echo "Operation completed successfully."
