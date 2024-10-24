#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/files"
    exit 1
fi

path="$1"

if [ ! -d "$path" ]; then
    echo "Error: $path is not a directory"
    exit 1
fi

cd $path
mkdir Eng

for file in "."/*
do
    if [ -f "$file" ]; then
        ffmpeg -i "${file}" -map 0:0 -map 0:2 -map 0:4 -acodec copy -vcodec copy "./Eng/${file}"
    fi
done
