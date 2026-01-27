#!/usr/bin/env bash
set -euo pipefail

# This section loads configuration files needed to set environment variables
# such as GITHUB_TOKEN. If these variables are already exported globally in the shell, 
# the files below can remain commented out. Otherwise, uncomment the appropriate 
# file(s) as needed. This particular script only needs GITHUB_TOKEN to function properly.

# source "$GITNAP/utils/auth.sh"
# source "$GITNAP/utils/settings.sh"



function delete_github_notifications() {
	local NOTIFICATION_ID
    local endpoint
    local response
    local tmp_file
    
    NOTIFICATION_ID="$1"

    # Checks if the parameter was provided.
    if [[ -z "$NOTIFICATION_ID" ]]; then
        echo "Provide id notification to delete"
        exit 1
    fi
    
    # API Endpoint
    endpoint="https://api.github.com/notifications/threads/$NOTIFICATION_ID"

    # Delete notifications
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X DELETE "$endpoint" \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" )

    echo "$response" 

}

delete_github_notifications "$1"
