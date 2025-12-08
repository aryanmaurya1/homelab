#!/bin/bash

set -e

if [ "$1" == "-u" ]; then
    echo "Unmounting all NBD devices..."
    for dev in /dev/nbd*; do
        if mount | grep -q "$dev"; then
            mountpoint=$(mount | grep "$dev" | awk '{print $3}')
            umount "$mountpoint"
            echo "Unmounted $mountpoint"
        fi
        qemu-nbd --disconnect "$dev" 2>/dev/null || true
    done
    rmmod nbd
    echo "All NBD devices disconnected and module removed."
    exit 0
fi

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <qcow2_image> <mount_point>"
    echo "       $0 -u (to unmount all NBD devices)"
    exit 1
fi

QCOW2_IMAGE="$1"
MOUNT_POINT="$2"

# Load NBD module
modprobe nbd max_part=8

# Connect the qcow2 image
qemu-nbd --connect=/dev/nbd0 "$QCOW2_IMAGE"

echo "Sleeping for 5 seconds"
sleep 5

# Mount First partition
PARTITION=/dev/nbd0p1
echo "Mounting $PARTITION to $MOUNT_POINT"
mkdir -p "$MOUNT_POINT"
mount "$PARTITION" "$MOUNT_POINT"

echo "Mounted successfully. When done, run:"
echo "  umount $MOUNT_POINT && qemu-nbd --disconnect /dev/nbd0 && rmmod nbd"
