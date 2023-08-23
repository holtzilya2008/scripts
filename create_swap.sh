#!/bin/bash

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <size_in_MB>"
    exit 1
fi

# Get the size from the command line argument
SWAP_SIZE_MB="$1"

echo "Creating the swap file..."
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count="$SWAP_SIZE_MB"

echo "Initializing the swap file..."
sudo /sbin/mkswap /var/swap.1

echo "Set appropriate permissions..."
sudo chmod 600 /var/swap.1

echo "Enable the swap file..."
sudo /sbin/swapon /var/swap.1

echo "Adding to fstab..."
echo "/var/swap.1 swap swap defaults 0 0" | sudo tee -a /etc/fstab > /dev/null

echo "Swap file of size ${SWAP_SIZE_MB}MB created and enabled."
