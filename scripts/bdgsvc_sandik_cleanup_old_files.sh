#!/bin/bash

SVC_NAME="bdgsvc_sandik"
TMPDIR="/mnt/${SVC_NAME}_tmp"
LOGFILE="/var/log/${SVC_NAME}/monitor.log"

# Remove old test files
find "$TMPDIR" -type f -mtime +1 -delete

# Record cleanup activity
echo "$(date): Cleanup completed." >> "$LOGFILE"
