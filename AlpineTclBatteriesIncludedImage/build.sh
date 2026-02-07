#!/bin/bash
docker build --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") --pull --no-cache -f DockerfileTcl9 -t tcl9bi-alpine .
docker build --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") --pull --no-cache -f DockerfileSysMallocTcl9BI -t tcl9bi-alpine-malloc .
