#!/bin/bash

path="$1"

if [ ! -d "$path" ]; then
  echo "Error: $path is not a valid directory"
  exit 1
fi

cd $path

# Loop through the subdirectories and create du and ls files
for subdir in "$path"/*/; do
  if [ -d "$subdir" ]; then
    base_name="$(basename "$subdir")"
    echo "proccessing $base_name"
    du $base_name -h > ./$base_name.du
    ls -lRa $base_name > ./$base_name.ls
  fi
done

echo "du and ls files are created for all subdirectories in $path"
