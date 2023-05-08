#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: randomName /path/to/names.csv"
    exit 1
fi

file_path="$1"

if [ ! -f "$file_path" ]; then
    echo "File not found: $file_path"
    exit 1
fi

mapfile -t first_names < <(tail -n +2 "$file_path" | cut -d, -f1)
mapfile -t last_names < <(tail -n +2 "$file_path" | cut -d, -f2)

first_name_count=${#first_names[@]}
last_name_count=${#last_names[@]}

random_first_name="${first_names[RANDOM % first_name_count]}"
random_last_name="${last_names[RANDOM % last_name_count]}"

echo "$random_first_name $random_last_name"
