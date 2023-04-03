#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <column number> <csv file>"
    exit 1
fi

column_num=$1
csv_file=$2

if [ ! -f "$csv_file" ]; then
    echo "$csv_file does not exist"
    exit 1
fi

cut -d',' -f"$column_num" "$csv_file" | sort -u
