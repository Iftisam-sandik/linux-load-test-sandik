#!/bin/bash

set -euo pipefail

SVC_NAME="${SVC_NAME:-bgdsvc_sandik}"

if id "$SVC_NAME" >/dev/null 2>&1; then
    echo "Service user '$SVC_NAME' already exists."
else
    sudo useradd -r -m -s /usr/sbin/nologin "$SVC_NAME"
    echo "Service user '$SVC_NAME' created successfully."
fi

id "$SVC_NAME"
getent passwd "$SVC_NAME"
