#!/usr/bin/env bash
set -euo pipefail

# This section loads configuration files needed to set environment variables
# such as GITHUB_TOKEN. If these variables are already exported globally in the shell, 
# the files below can remain commented out. Otherwise, uncomment the appropriate 
# file(s) as needed. This particular script only needs GITHUB_TOKEN to function properly.

# source "$GITNAP/utils/auth.sh"
# source "$GITNAP/utils/settings.sh"



function list_github_notifications() {
    local endpoint
    local response
    local tmp_file

    # API Endpoint
    endpoint="https://api.github.com/notifications"

    # Get notifications
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L "$endpoint" \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" )
    
    # See in terminal
    tmp_file=$(mktemp)
    echo "$response" > "$tmp_file"
    less "$tmp_file"
    rm "$tmp_file"

}

list_github_notifications
