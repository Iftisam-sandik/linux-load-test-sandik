#!/bin/bash

SVC_NAME="bdgsvc_sandik"
LOGFILE="/var/log/$SVC_NAME/monitor.log"

echo "----- $(date) -----" >> "$LOGFILE"

free -h >> "$LOGFILE" 2>&1

df -h "/mnt/${SVC_NAME}_tmp" >> "$LOGFILE" 2>&1

ps -u "$SVC_NAME" >> "$LOGFILE" 2>&1

echo "" >> "$LOGFILE"
