#!/bin/bash

set -u

SVC_NAME="${SVC_NAME:-bgdsvc_sandik}"
MOUNT_DIR="/mnt/${SVC_NAME}_tmp"
LOG_DIR="/var/log/${SVC_NAME}"
LOGROTATE_CONF="/etc/logrotate.d/${SVC_NAME}"
MONITOR_SCRIPT="/usr/local/bin/${SVC_NAME}_monitor.sh"
CLEANUP_SCRIPT="/usr/local/bin/${SVC_NAME}_cleanup_old_files.sh"

echo "Starting cleanup for $SVC_NAME..."
echo

# 1. Stop service-user processes
if id "$SVC_NAME" >/dev/null 2>&1; then
    sudo pkill -u "$SVC_NAME" 2>/dev/null || true
    echo "Service user processes stopped."
else
    echo "Service user is already absent."
fi

# 2. Remove automation
if id "$SVC_NAME" >/dev/null 2>&1; then
    sudo crontab -r -u "$SVC_NAME" 2>/dev/null || true
fi

sudo rm -f "$LOGROTATE_CONF"
sudo rm -f "$MONITOR_SCRIPT"
sudo rm -f "$CLEANUP_SCRIPT"

echo "Cron jobs and automation files removed."

# 3. Unmount and remove tmpfs mount point
if mountpoint -q "$MOUNT_DIR"; then
    if sudo umount "$MOUNT_DIR"; then
        echo "tmpfs unmounted."
    else
        echo "ERROR: Could not unmount $MOUNT_DIR."
        exit 1
    fi
else
    echo "tmpfs is already unmounted."
fi

if [ -d "$MOUNT_DIR" ]; then
    sudo rmdir "$MOUNT_DIR" 2>/dev/null || true
fi

echo "Mount directory removed."

# 4. Remove service logs
if [ -d "$LOG_DIR" ]; then
    sudo rm -rf "$LOG_DIR"
    echo "Service logs removed."
else
    echo "Service log directory is already absent."
fi

# 5. Remove service identity
if id "$SVC_NAME" >/dev/null 2>&1; then
    sudo userdel -r "$SVC_NAME"
    echo "Service user removed."
else
    echo "Service user is already absent."
fi

echo
echo "Cleanup completed."
