# Linux Load Test Assignment

BongoDev Linux Fundamentals / DevOps Practical Lab

## Service Account

`bgdsvc_sandik`

## Progress

- Part 1 — Service user creation: Completed
- Part 2 — tmpfs setup: Cpmpleted
- Part 3 — Stress testing: cpmpleted
- Part 4 — SSH key access: Completed
- Part 5 — SSH hardening: Completed
- Part 6 — Cron monitoring: Completed
- Part 7 — Logrotate: Completed
- Part 8 — Cleanup: Pending

## SSH Key Access

An ED25519 key pair was created for `bgdsvc_sandik`, and the public key was installed in the service account's `authorized_keys` file.

The service account was originally created with `/usr/sbin/nologin` as required in Part 1. For the SSH access test in Part 4, its live login shell was changed to `/bin/bash` so that key-based interactive SSH access could be verified successfully.

The private SSH key is stored outside the repository and is not committed.


## SSH Hardening

SSH access was hardened with the following effective settings:

- Port: `2222`
- Root login: disabled
- Password authentication: disabled
- Allowed SSH user: `bgdsvc_sandik`

The hardened SSH configuration was validated with `sshd -T`, and the SSH daemon was confirmed to listen on port `2222`. Key-based authentication to the service account on port `2222` completed successfully.


## Automated Monitoring and Cleanup

The service account has two scheduled cron jobs:

- Resource monitoring runs every 5 minutes.
- Old tmpfs files are cleaned daily at 2:00 AM.

The monitoring script records memory usage, tmpfs usage, and service-account processes in `/var/log/bgdsvc_sandik/monitor.log`.

The monitoring cron job was verified to execute automatically, and the cleanup script was also tested successfully.

## Log Rotation

Log rotation was configured for `/var/log/bgdsvc_sandik/*.log` with the following settings:

- Daily rotation policy
- Keep 5 rotated logs
- Compress rotated logs
- Ignore missing and empty logs
- Rotate when the log reaches 10 MB
- Create new logs with mode `0640`
- Owner and group: `bgdsvc_sandik`

The configuration was tested with a forced rotation. The existing log was compressed as `monitor.log.1.gz`, a new `monitor.log` was created with the expected ownership and permissions, and the monitoring script successfully continued writing to the new log.
