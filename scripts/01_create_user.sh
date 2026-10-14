#!/bin/bash
set -euo pipefail

: "${SVC_NAME:?SVC_NAME is not set}"

if getent passwd "$SVC_NAME" > /dev/null; then
    echo "User $SVC_NAME already exists. Skipping."
else
    sudo useradd -r -m -s /usr/sbin/nologin "$SVC_NAME"
    echo "User $SVC_NAME created successfully."
fi
