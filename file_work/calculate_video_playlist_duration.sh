#!/bin/bash

# Path to your .m3u file
M3U_PATH="$1"

# Ensure a file path is provided
if [[ -z "$M3U_PATH" ]]; then
  echo "Usage: $0 path_to_playlist.m3u"
  exit 1
fi

# Total duration variable
total_duration=0

# Read each line from the M3U file
while IFS= read -r line; do
  # Skip lines that are comments or empty
  if [[ "$line" == \#* ]] || [[ -z "$line" ]]; then
    continue
  fi

  # Use ffprobe to get the duration of the file
  file_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$line" 2>/dev/null)

  # Add the duration to the total, if it's a number
  if [[ "$file_duration" =~ ^[0-9.]+$ ]]; then
    total_duration=$(echo "$total_duration + $file_duration" | bc)
  fi
done < "$M3U_PATH"

# Print the total duration in seconds
echo "Total duration: $total_duration seconds"

# Optional: convert seconds to hours, minutes, and seconds
echo $total_duration | awk '{printf "Total duration: %d hours %d minutes %d seconds\n", $1/3600, ($1%3600)/60, $1%60}'
