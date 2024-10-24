#!/bin/bash

# Script: trim_silence
# Description: This script trims an MP3 file up to the first detected silence point using ffmpeg's silencedetect filter.

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null
then
    echo "Error: ffmpeg is not installed. Please install it and try again."
    exit 1
fi

# Validate input parameters
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

# Check if file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found!"
    exit 1
fi

# Detect silence and extract the first valid silence start time
ffmpeg_output=$(ffmpeg -i "$input_file" -af "silencedetect=n=-48dB:d=60" -f null - 2>&1)

# Debug: Show the relevant silence detection output
echo "Raw silence detection output:"
echo "$ffmpeg_output" | grep 'silence_start'

# Extract the first non-zero silence_start time
silence_start=$(echo "$ffmpeg_output" | grep -oP 'silence_start: \K[\d\.]+' | grep -m 1 -v '^0')

# Check if silence start time was found and is valid
if [ -z "$silence_start" ]; then
    echo "No valid silence detected, or no silence longer than 60 seconds found."
    exit 1
fi

echo "Silence detected at $silence_start seconds."

# Round silence start time to the nearest integer
silence_start_rounded=$(printf "%.0f" "$silence_start")

# Trim the file up to the detected silence start
output_file="${input_file%.*}_tr.mp3"
ffmpeg -i "$input_file" -t "$silence_start_rounded" -acodec copy "$output_file"

echo "Trimmed file saved as $output_file"
