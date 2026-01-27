#!/usr/bin/env bash
set -euo pipefail


function edit_gitlab_repo() {
    local REPO
    local OWNER
    local new_description
    local payload
    local endpoint
    local response
    
    # Get the new description as an argument
    new_description="$1"

    # Checks if the parameter was provided
    if [[ -z "$new_description" ]]; then
        echo "A new description is required."
        exit 1
    fi

    # Name of repository
    REPO="$2"
    
    # Checks if the parameter was provided or use the name of the current directory
    if [[ -z "$REPO" ]]; then
        REPO=$(basename "$PWD")
    fi
    
    # Repo owner
    OWNER="$3"
    
    # Checks if the parameter was provided or use the default
    if [[ -z "$OWNER" ]]; then
        OWNER="$DEF_GH_OWNER"
    fi
    
    # Create the JSON payload for the repository
    payload='{"description": "'"$new_description"'"}'
    
    # Construct API Endpoint
    SLASH_ENCODED="%2F"
    endpoint="https://gitlab.com/api/v4/projects/$OWNER$SLASH_ENCODED$REPO"
        
    # Edit GitLab repository using curl
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X PUT "$endpoint" \
        -H "Authorization: Bearer $GITLAB_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$payload" )
    
    # Check if there are erros
    echo "$response" | jq -r '.message'
}


edit_gitlab_repo "$1" "$2" "$3"
