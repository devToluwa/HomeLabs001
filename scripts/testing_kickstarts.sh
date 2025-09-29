#!/bin/bash

# File: scripts/test_kickstarts.sh
# Purpose: Test access to Kickstart files on the masternode Apache server

# Replace with your masternode IP or hostname
SERVER_IP="192.168.14.161"
KS_PATH="kickstarts"

# List of Kickstart files
FILES=(
    "vm1-web-ks.cfg"
    "vm2-db-ks.cfg"
    "vm3-monitoring-ks.cfg"
    "vm4-backup-ks.cfg"
    "vm5-security-ks.cfg"
)

for file in "${FILES[@]}"; do
    # Perform curl and save HTTP status code
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://$SERVER_IP/$KS_PATH/$file)

    if [ "$HTTP_STATUS" -eq 200 ]; then
        echo "$file was successfully accessed."
    else
        echo "$file could not be accessed (HTTP $HTTP_STATUS)."
    fi
done

