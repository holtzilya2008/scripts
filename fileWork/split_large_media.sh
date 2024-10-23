#!/bin/bash

# Script: split_large_media
# Description: This script splits a large MP3 file into smaller chunks of 10 minutes each.
# The last file will contain the remainder, and each part will be named based on the original file
# with a numerical suffix (e.g., input_001.mp3, input_002.mp3, etc.)

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null
then
    echo "ffmpeg is not installed. Please install it and try again."
    exit 1
fi

# Check if input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

# Check if file exists
if [ ! -f "$input_file" ]; then
    echo "File '$input_file' not found!"
    exit 1
fi

# Set constants
CHUNK_DURATION=600  # 600 seconds = 10 minutes

# Get the total duration of the input file in seconds (rounding to integer)
total_duration=$(ffmpeg -i "$input_file" 2>&1 | grep "Duration" | awk '{print $2}' | tr -d , | awk -F: '{ print ($1 * 3600) + ($2 * 60) + int($3) }')

# Calculate the number of parts (integer division)
num_parts=$((total_duration / CHUNK_DURATION))
remainder=$((total_duration % CHUNK_DURATION))

# If there's a remainder, add one more part for the final chunk
if [ "$remainder" -gt 0 ]; then
    num_parts=$((num_parts + 1))
fi

echo "Total duration: $total_duration seconds"
echo "Number of parts: $num_parts"
echo "Remainder: $remainder seconds (for the last part)"

# Extract the file name without extension
base_name=$(basename "$input_file" .mp3)

# Split the file
for ((i=0; i<num_parts; i++)); do
    # Calculate the start time for the current part
    start_time=$((i * CHUNK_DURATION))

    # Create the output file name with zero-padded part numbers
    part_number=$(printf "%03d" $((i + 1)))
    output_file="${base_name}_${part_number}.mp3"

    # Determine the duration for the current part (last part may have less than 10 minutes)
    if [ "$i" -eq "$((num_parts - 1))" ] && [ "$remainder" -gt 0 ]; then
        duration="$remainder"
    else
        duration="$CHUNK_DURATION"
    fi

    echo "Splitting part $((i + 1))..."
    echo "Creating file: $output_file (starting at $start_time seconds, duration: $duration seconds)"

    ffmpeg -v quiet -y -i "$input_file" -ss "$start_time" -t "$duration" -acodec copy "$output_file"

    echo "File $output_file created."
done

echo "Splitting complete!"
