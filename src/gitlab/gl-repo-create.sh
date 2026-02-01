#!/usr/bin/env bash
set -euo pipefail


function create_gitlab_repo() {
    local repo
    local payload
    local endpoint
    local response
    
    # Name of repository
    repo="$1"
    
    # Checks if the parameter was provided or use the name of the current directory
    if [[ -z "$repo" ]]; then
        repo=$(basename "$PWD")
    fi

    # Create the JSON payload for the repository
    payload='{"name": "'"$repo"'", "visibility": "private"}'
    
    # Construct API Endpoint
    endpoint="https://gitlab.com/api/v4/projects"
    
    # Create GitLab repository using curl
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X POST "$endpoint" \
        -H "Authorization: Bearer $GITLAB_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$payload" )
    
    # Check if there are erros
    echo "$response" | jq -r '.ssh_url_to_repo // .message'
    
    return 0
}


create_gitlab_repo "$1"
