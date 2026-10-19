#!/bin/bash

set -euo pipefail

SVC_NAME="${SVC_NAME:-bgdsvc_sandik}"
MOUNT_DIR="/mnt/${SVC_NAME}_tmp"

if ! id "$SVC_NAME" >/dev/null 2>&1; then
    echo "Error: Service user '$SVC_NAME' does not exist."
    exit 1
fi

sudo mkdir -p "$MOUNT_DIR"

if mountpoint -q "$MOUNT_DIR"; then
    echo "tmpfs is already mounted at $MOUNT_DIR."
else
    sudo mount -t tmpfs -o size=256M tmpfs "$MOUNT_DIR"
    echo "256M tmpfs mounted successfully at $MOUNT_DIR."
fi

sudo chown "$SVC_NAME:$SVC_NAME" "$MOUNT_DIR"

df -h "$MOUNT_DIR"
