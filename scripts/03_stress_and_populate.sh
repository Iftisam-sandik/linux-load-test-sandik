#!/bin/bash

set -euo pipefail

SVC_NAME="${SVC_NAME:-bgdsvc_sandik}"
MOUNT_DIR="/mnt/${SVC_NAME}_tmp"

# Check service user
if ! id "$SVC_NAME" >/dev/null 2>&1; then
    echo "Error: Service user '$SVC_NAME' does not exist."
    exit 1
fi

# Check tmpfs mount
if ! mountpoint -q "$MOUNT_DIR"; then
    echo "Error: tmpfs is not mounted at $MOUNT_DIR."
    exit 1
fi

# Check stress-ng installation
if ! command -v stress-ng >/dev/null 2>&1; then
    echo "Error: stress-ng is not installed."
    exit 1
fi

# CPU stress test
run_cpu() {
    echo "Starting CPU stress test..."

    (
        cd /tmp
        sudo -u "$SVC_NAME" stress-ng \
            --cpu 2 \
            --timeout 30s \
            --metrics-brief
    )

    echo "CPU stress test completed."
}

# Memory stress test
run_mem() {
    echo "Starting memory stress test..."

    (
        cd /tmp
        sudo -u "$SVC_NAME" stress-ng \
            --vm 1 \
            --vm-bytes 200M \
            --timeout 30s \
            --metrics-brief
    )

    echo "Memory stress test completed."
}

# tmpfs disk population test
run_disk() {
    echo "Starting tmpfs disk population..."

    for i in $(seq 1 20); do
        sudo -u "$SVC_NAME" dd \
            if=/dev/urandom \
            of="${MOUNT_DIR}/file_${i}.dat" \
            bs=1M \
            count=10 \
            status=none

        df -h "$MOUNT_DIR"
    done

    echo "Disk population completed."
}

# Combined CPU, memory, and disk stress test
run_all() {
    echo "Starting combined CPU, memory, and disk stress test..."

    run_cpu &
    CPU_PID=$!

    run_mem &
    MEM_PID=$!

    run_disk &
    DISK_PID=$!

    wait "$CPU_PID"
    wait "$MEM_PID"
    wait "$DISK_PID"

    echo "Combined stress test completed."
}

case "${1:-}" in
    --cpu)
        run_cpu
        ;;
    --mem)
        run_mem
        ;;
    --disk)
        run_disk
        ;;
    --all)
        run_all
        ;;
    *)
        echo "Usage: $0 {--cpu|--mem|--disk|--all}"
        exit 1
        ;;
esac
