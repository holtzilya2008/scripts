#!/bin/bash

# Internal variable for the path to the root of the git repository
backups_repo_root="/home/ilya/dev/backups" # Replace with your actual repository path

# Function to display usage information
usage() {
    echo "Usage: $0 backup_name source_path dest_path [--delete] [--no-commit]"
    echo "  backup_name: Name of the backup"
    echo "  source_path: Path to the source directory"
    echo "  dest_path: Path to the destination directory"
    echo "  --delete: Pass this option to delete files in dest_path not present in source_path"
    echo "  --no-commit: Pass this option to skip git commit"
    exit 1
}

# Check for --help option
if [ "$1" == "--help" ]; then
    usage
fi

# Validate the number of arguments
if [ "$#" -lt 3 ]; then
    echo "Error: Missing arguments."
    usage
fi

# Assign command line arguments
backup_name="$1"
source_path="$2"
dest_path="$3"
delete_flag=""
commit_flag=true

# Check for optional arguments
for arg in "$@"; do
    if [ "$arg" == "--delete" ]; then
        delete_flag="--delete"
    elif [ "$arg" == "--no-commit" ]; then
        commit_flag=false
    fi
done

# Run rsync command
rsync_cmd="rsync -rtvu $delete_flag \"$source_path\" \"$dest_path\""
eval $rsync_cmd

# Check if rsync was successful
if [ $? -ne 0 ]; then
    echo "Error: Rsync command failed."
    exit 1
fi

# Proceed with git operations if commit_flag is true
if $commit_flag; then
    # Navigate to the git repository
    cd "$backups_repo_root"

    # Stash any changes, checkout master, and pull latest changes
    git stash
    git checkout master
    git pull

    # Log the backup
    current_date=$(date)
    echo "$current_date :: $rsync_cmd" >> "$backups_repo_root/backup_drives/last_backup.log"

    # Commit and push the changes
    git add --all .
    git commit -m "$current_date Backup : $backup_name"
    git push
fi

# Print completion message
echo "Backup completed successfully."
