#!/bin/bash
set -euo pipefail

: "${SVC_NAME:?SVC_NAME is not set}"

MOUNT_DIR="/mnt/${SVC_NAME}_tmp"

sudo mkdir -p "$MOUNT_DIR"

if mountpoint -q "$MOUNT_DIR"; then
    echo "tmpfs already mounted. Skipping."
else
    sudo mount -t tmpfs -o size=256M tmpfs "$MOUNT_DIR"
    echo "tmpfs mounted successfully."
fi

sudo chown "$SVC_NAME:$SVC_NAME" "$MOUNT_DIR"

df -h "$MOUNT_DIR"
