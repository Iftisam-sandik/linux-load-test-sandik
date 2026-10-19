# Load Test Observations

During the load test, the 256 MB tmpfs reached about 200 MB of usage, or 79%, after the disk population test. The CPU stress test used two CPU workers for 30 seconds, while the memory stress test allocated 200 MB for 30 seconds. During the combined CPU, memory, and disk test, system resource usage increased noticeably, but the server remained responsive and no Out-Of-Memory (OOM) event was detected.

If this were a real production server, I would avoid intentionally pushing resources close to their limits without safeguards. I would configure proper monitoring and alerting for CPU, memory, disk usage, and OOM events, define safe resource limits, maintain sufficient capacity headroom, and perform load testing in a controlled staging environment before production deployment.
