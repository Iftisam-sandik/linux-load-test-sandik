#!/bin/bash

set -euo pipefail

SVC_NAME="${SVC_NAME:-bdgsvc_sandik}"
MOUNT_DIR="/mnt/${SVC_NAME}_tmp"
LOG_DIR="/var/log/${SVC_NAME}"

# 1. Stop service user processes
if id "$SVC_NAME" > /dev/null 2>&1; then
    sudo pkill -u "$SVC_NAME" || true
fi

# 2. Remove cron jobs
if id "$SVC_NAME" > /dev/null 2>&1; then
    sudo crontab -r -u "$SVC_NAME" 2>/dev/null || true
fi

# 3. Remove automation files
sudo rm -f "/etc/logrotate.d/${SVC_NAME}"
sudo rm -f "/usr/local/bin/${SVC_NAME}_monitor.sh"
sudo rm -f "/usr/local/bin/${SVC_NAME}_cleanup_old_files.sh"

# 4. Unmount tmpfs
if mountpoint -q "$MOUNT_DIR"; then
    sudo umount "$MOUNT_DIR"
fi

# 5. Remove mount directory
if [ -d "$MOUNT_DIR" ]; then
    sudo rmdir "$MOUNT_DIR"
fi

# 6. Remove logs
sudo rm -rf "$LOG_DIR"

# 7. Remove service user
if id "$SVC_NAME" > /dev/null 2>&1; then
    sudo userdel -r "$SVC_NAME"
fi

echo "Cleanup completed successfully."
