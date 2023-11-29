#!/bin/bash

# Define Dependency-Check version
DC_VERSION="latest"

# Define directories
DC_DIRECTORY="/var/lib/jenkins/OWASP-Dependency-Check"
DATA_DIRECTORY="$DC_DIRECTORY/data"
CACHE_DIRECTORY="$DATA_DIRECTORY/cache"
REPORT_DIRECTORY="$DC_DIRECTORY/reports"

# Create necessary directories if they don't exist
mkdir -p "$DATA_DIRECTORY"
mkdir -p "$CACHE_DIRECTORY"
mkdir -p "$REPORT_DIRECTORY"

# Pull the latest Dependency-Check Docker image
docker pull owasp/dependency-check:$DC_VERSION

# Run Dependency-Check scan
docker run --rm \
    -u $(id -u):$(id -g) \
    -e HOME=/tmp \
    -v "$(pwd)":/src \
    -v "$DATA_DIRECTORY":/usr/share/dependency-check/data \
    -v "$CACHE_DIRECTORY":/usr/share/dependency-check/data/cache \
    -v "$REPORT_DIRECTORY":/report \
    owasp/dependency-check:$DC_VERSION \
    --scan /src \
    --format "XML" \
    --project "My Project" \
    --out /report/dependency-check-report.xml
