#!/bin/bash
# mount_ntfs_external.sh
#
# A helper script to mount NTFS external drives to /media/<user>/<label>.
#
# Usage:
#   ./mount_ntfs_external.sh <DEVICE> [-u <USER>] [-h|--help]
#
# Arguments:
#   DEVICE       Required. The NTFS block device to mount (e.g. /dev/sdc1).
#
# Options:
#   -u USER      Optional. The username that should own the mount point.
#                Defaults to the current logged-in user.
#   -h, --help   Show this help message and exit.
#
# Examples:
#   ./mount_ntfs_external.sh /dev/sdc1
#   ./mount_ntfs_external.sh /dev/sdb1 -u ilya
#
# Notes:
#   - Creates the mount point at /media/<user>/<label>.
#   - Uses ntfs-3g to mount with proper ownership.
#   - Requires sudo privileges.

set -e

show_help() {
    grep '^#' "$0" | sed 's/^#//'
    exit 0
}

# Default user = current
CURRENT_USER_NAME=$(id -un)
USER_NAME="$CURRENT_USER_NAME"

# Parse args
if [[ $# -eq 0 ]]; then
    show_help
fi

POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -u)
            USER_NAME="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        -*)
            echo "Unknown option: $1"
            show_help
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

if [[ ${#POSITIONAL_ARGS[@]} -lt 1 ]]; then
    echo "Error: DEVICE argument is required."
    show_help
fi

DEVICE="${POSITIONAL_ARGS[0]}"

# Validate device
if [[ ! -b "$DEVICE" ]]; then
    echo "Error: $DEVICE is not a valid block device."
    exit 1
fi

# Get uid/gid
MY_UID=$(id -u "$USER_NAME")
MY_GID=$(id -g "$USER_NAME")

# Determine label
LABEL=$(blkid -o value -s LABEL "$DEVICE" 2>/dev/null || echo "ntfs_drive")
if [[ -z "$LABEL" ]]; then
    LABEL="ntfs_drive"
fi

MOUNT_POINT="/media/$USER_NAME/$LABEL"

echo "[*] Creating mount point at $MOUNT_POINT..."
sudo mkdir -p "$MOUNT_POINT"
sudo chown "$USER_NAME:$USER_NAME" "$MOUNT_POINT"
sudo chmod 755 "$MOUNT_POINT"

echo "[*] Mounting $DEVICE (NTFS) to $MOUNT_POINT..."
sudo mount -t ntfs-3g -o uid=$MY_UID,gid=$MY_GID,umask=022 "$DEVICE" "$MOUNT_POINT"

echo "[✓] NTFS drive mounted successfully at $MOUNT_POINT"
