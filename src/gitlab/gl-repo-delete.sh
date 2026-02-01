#!/usr/bin/env bash
set -euo pipefail


function delete_gitlab_repo() {
    local repo
    local owner
    local endpoint
    local response
        
    # Name of repository
    repo="$1"
    
    # Checks if the parameter was provided or use the name of the current directory
    if [[ -z "$repo" ]]; then
        repo=$(basename "$PWD")
    fi

    # Repo owner
    owner="$2"
    
    # Checks if the parameter was provided or use the default
    if [[ -z "$owner" ]]; then
        owner="$DEF_GL_OWNER"
    fi
        
    # Construct API Endpoint
    slash_encoded="%2F"
    endpoint="https://gitlab.com/api/v4/projects/$owner$slash_encoded$repo"
        
    # Confirm deletion before proceeding
    echo "Are you sure you want to delete the repository '$repo' (y/N)?"
    read -r confirmation
    
    if [[ $confirmation =~ ^[Yy]$ ]]; then
        # Delete the repository using curl
        response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X DELETE "$endpoint" \
            -H "Authorization: Bearer $GITLAB_TOKEN" )

        echo "$response" | jq -r '.message'
    else
        echo "Deletion cancelled."
    fi    
    
    return 0
}


delete_gitlab_repo "$1" "$2"
