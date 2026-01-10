#!/bin/bash

# Usage:
#   ./enc_qcow2_mount.sh /path/to/encrypted.qcow2 /mount/point
#   ./enc_qcow2_mount.sh -u   # to unmount everything

set -e

MAPPER_NAME="encrypted_disk"

# Function to find a free nbd device
find_free_nbd() {
    for dev in /dev/nbd*; do
        # Check if nbd is connected
        if [[ ! -f "/sys/block/$(basename $dev)/pid" ]] || [[ $(cat /sys/block/$(basename $dev)/pid) == "" ]]; then
            echo "$dev"
            return
        fi
    done
    echo "No free /dev/nbd devices found" >&2
    exit 1
}

if [[ "$1" == "-u" ]]; then
    echo "Unmounting and cleaning up..."
    if mount | grep -q "$MAPPER_NAME"; then
        MOUNTPOINT=$(mount | grep "$MAPPER_NAME" | awk '{print $3}')
        sudo umount "$MOUNTPOINT"
        echo "Unmounted $MOUNTPOINT"
    fi

    if sudo cryptsetup status "$MAPPER_NAME" &>/dev/null; then
        sudo cryptsetup luksClose "$MAPPER_NAME"
        echo "Closed LUKS mapper $MAPPER_NAME"
    fi

    for dev in /dev/nbd*; do
        if sudo qemu-nbd --disconnect "$dev" 2>/dev/null; then
            echo "Disconnected $dev"
        fi
    done

    sudo rmmod nbd || true
    echo "Removed nbd module"
    exit 0
fi

# Normal mount mode
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 /path/to/encrypted.qcow2 /mount/point"
    exit 1
fi

QCOW2_PATH="$1"
MOUNT_PATH="$2"

# Load nbd module
sudo modprobe nbd max_part=8

# Find free nbd device
NBD_DEV=$(find_free_nbd)
echo "Using NBD device $NBD_DEV"

# Connect qcow2 to nbd
sudo qemu-nbd --connect="$NBD_DEV" "$QCOW2_PATH"

# Open LUKS
sudo cryptsetup luksOpen "$NBD_DEV" "$MAPPER_NAME"

# Make sure mount point exists
sudo mkdir -p "$MOUNT_PATH"

# Mount the filesystem
sudo mount "/dev/mapper/$MAPPER_NAME" "$MOUNT_PATH"

echo "Encrypted QCOW2 mounted at $MOUNT_PATH"
