#!/bin/bash

set -u

SVC_NAME="bgdsvc_sandik"
LOGFILE="/var/log/${SVC_NAME}/monitor.log"
MOUNT_DIR="/mnt/${SVC_NAME}_tmp"

echo "---- $(date) ----" >> "$LOGFILE"
free -h >> "$LOGFILE"
df -h "$MOUNT_DIR" >> "$LOGFILE" 2>&1
ps -u "$SVC_NAME" >> "$LOGFILE" 2>&1
echo >> "$LOGFILE"
