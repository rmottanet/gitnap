#!/usr/bin/env bash
set -euo pipefail


function edit_gitlab_repo() {
    local repo
    local owner
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
    repo="$2"
    
    # Checks if the parameter was provided or use the name of the current directory
    if [[ -z "$repo" ]]; then
        repo=$(basename "$PWD")
    fi
    
    # Repo owner
    owner="$3"
    
    # Checks if the parameter was provided or use the default
    if [[ -z "$owner" ]]; then
        owner="$DEF_GL_OWNER"
    fi
    
    # Create the JSON payload for the repository
    payload='{"description": "'"$new_description"'"}'
    
    # Construct API Endpoint
    slash_encoded="%2F"
    endpoint="https://gitlab.com/api/v4/projects/$owner$slash_encoded$repo"
        
    # Edit GitLab repository using curl
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X PUT "$endpoint" \
        -H "Authorization: Bearer $GITLAB_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$payload" )
    
    # Check if there are erros
    echo "$response" | jq -r '.message'
    
    return 0
}


edit_gitlab_repo "$1" "$2" "$3"
