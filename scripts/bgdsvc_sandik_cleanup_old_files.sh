#!/bin/bash

set -u

SVC_NAME="bgdsvc_sandik"
TMPDIR="/mnt/${SVC_NAME}_tmp"
LOGFILE="/var/log/${SVC_NAME}/monitor.log"

find "$TMPDIR" -type f -mtime +1 -delete

echo "$(date): cleanup run - removed files older than 1 day from $TMPDIR" >> "$LOGFILE"
