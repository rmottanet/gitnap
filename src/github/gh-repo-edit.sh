#!/usr/bin/env bash
set -euo pipefail


function edit_github_repo() {
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
    endpoint="https://api.github.com/repos/$OWNER/$REPO"
    
    # Edit the repository using curl
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X PATCH "$endpoint" \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        -d "$payload" )
    
    # Check if there are erros
    echo "$response" | jq -r '.message'
}


edit_github_repo "$1" "$2" "$3"
