#!/usr/bin/env bash
set -euo pipefail


function create_github_repo() {
    local REPO
    local payload
    local endpoint
    local response
    
    # Name of repository
    REPO="$1"
    
    # Checks if the parameter was provided or use the name of the current directory
    if [[ -z "$REPO" ]]; then
        REPO=$(basename "$PWD")
    fi
    
    # Create the JSON payload for the repository
    payload='{"name": "'"$REPO"'", "private": true}'

    # API Endpoint
    endpoint="https://api.github.com/user/repos"
    
    # Create the repository using curl
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X POST "$endpoint" \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        -d "$payload" )

    # Check if there are erros
    echo "$response" | jq -r '.ssh_url // .message'
    
    return 0
}


create_github_repo "$1"
