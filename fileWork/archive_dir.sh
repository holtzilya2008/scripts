#!/bin/bash

dirname="$1"

if [ ! -d "$dirname" ]; then
  echo "Error: $dirname is not a valid directory"
  # If the provided "dirname" is not a directory, print an error message.
  exit 1
fi

mkdir -p ./removed
# Create a new directory called "removed" if it doesn't already exist. The "-p" flag allows for creating nested directories if needed.

du -h "$dirname" > "$dirname".du
# Run the "du" command to calculate the disk usage of the specified directory and use the "-h" flag to make the output human-readable. Then, redirect the output to a file named "dirname.du".

ls -Rla "$dirname" > "$dirname".ls
# Run the "ls" command with flags "-R" for recursive listing, "-l" for long format, and "-a" for showing hidden files. Redirect the output to a file named "dirname.ls".

env GZIP=-9 tar cvzf "$dirname".tar.gz "$dirname"
# Set the GZIP environment variable to "-9" for maximum compression, and run the "tar" command with flags "c" for create, "v" for verbose, "z" for gzip compression, and "f" for specifying the archive file. Create a compressed tarball named "dirname.tar.gz" containing the specified directory.

mv "$dirname" ./removed
# Move the original directory to the "removed" directory.
