# Linux Load Test Assignment

**BongoDev Linux Fundamentals / DevOps Practical Lab**

## Service Account

`bgdsvc_sandik`

## Assignment Status

- Part 1 — Service user creation: Completed
- Part 2 — tmpfs setup: Completed
- Part 3 — Stress testing: Completed
- Part 4 — SSH key access: Completed
- Part 5 — SSH hardening: Completed
- Part 6 — Cron monitoring: Completed
- Part 7 — Logrotate: Completed
- Part 8 — Cleanup: Completed

## Part 1 — Service Identity

The dedicated service account `bgdsvc_sandik` was created using an idempotent script. It was initially configured with `/usr/sbin/nologin` as its shell.

## Part 2 — tmpfs Storage

A 256 MB tmpfs filesystem was mounted at:

`/mnt/bgdsvc_sandik_tmp`

The mount was owned by the service account and the configured size cap was verified.

## Part 3 — Load Testing

CPU, memory, disk, and combined load tests were performed.

The stress script supports:

- `--cpu`
- `--mem`
- `--disk`
- `--all`

The disk population test used approximately 200 MB of the 256 MB tmpfs.

The CPU test used two CPU workers for 30 seconds.

The memory test allocated 200 MB for approximately 30 seconds.

The combined test was monitored with `free -h`, `top`, and the kernel log for OOM events. No OOM event was detected.

## Part 4 — SSH Key Access

An ED25519 SSH key pair was created for `bgdsvc_sandik`, and its public key was installed in the service account's `authorized_keys` file.

The service account was originally created with `/usr/sbin/nologin`. Its live shell was changed to `/bin/bash` during the SSH access phase so interactive key-based SSH access could be tested.

The private SSH key is not stored in this repository.

## Part 5 — SSH Hardening

SSH was hardened and validated with the following settings:

- Port `2222`
- Root login disabled
- Password authentication disabled
- SSH access restricted to `bgdsvc_sandik`

Key-based SSH authentication on port `2222` was tested successfully.

## Part 6 — Automated Monitoring and Cleanup

Two cron jobs were configured for the service account.

Resource monitoring ran every 5 minutes using:

`/usr/local/bin/bgdsvc_sandik_monitor.sh`

Old tmpfs files were scheduled for cleanup every day at 2:00 AM using:

`/usr/local/bin/bgdsvc_sandik_cleanup_old_files.sh`

The monitoring cron job was verified to execute automatically.

## Part 7 — Log Rotation

Log rotation was configured for:

`/var/log/bgdsvc_sandik/*.log`

Configuration:

- `daily`
- `rotate 5`
- `compress`
- `missingok`
- `notifempty`
- `size 10M`
- New log mode `0640`
- Owner/group `bgdsvc_sandik:bgdsvc_sandik`

A forced rotation was performed successfully. The old log was compressed and the monitoring script continued writing to the newly created log.

## Part 8 — Cleanup

The cleanup script removes the environment in reverse order:

1. Stop service-user processes
2. Remove cron and automation files
3. Unmount and remove tmpfs storage
4. Remove service logs
5. Remove the service account

The cleanup script was tested for idempotency and final verification confirmed that the service account, tmpfs mount, and service-account processes were removed.

## Evidence

Required screenshots are stored in the `screenshots/` directory.

## Security

No private SSH key, EC2 key pair, public IP address, or private IP address is intentionally stored in this repository.
