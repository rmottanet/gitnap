#!/usr/bin/env bash
set -euo pipefail


function delete_gitlab_repo() {
    local REPO
    local OWNER
    local endpoint
    local response
        
    # Name of repository
    REPO="$1"
    
    # Checks if the parameter was provided or use the name of the current directory
    if [[ -z "$REPO" ]]; then
        REPO=$(basename "$PWD")
    fi

    # Repo owner
    OWNER="$2"
    
    # Checks if the parameter was provided or use the default
    if [[ -z "$OWNER" ]]; then
        OWNER="$DEF_GL_OWNER"
    fi
        
    # Construct API Endpoint
    SLASH_ENCODED="%2F"
    endpoint="https://gitlab.com/api/v4/projects/$OWNER$SLASH_ENCODED$REPO"
        
    # Confirm deletion before proceeding
    echo "Are you sure you want to delete the repository '$REPO' (y/N)?"
    read -r confirmation
    
    if [[ $confirmation =~ ^[Yy]$ ]]; then
        # Delete the repository using curl
        response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X DELETE "$endpoint" \
            -H "Authorization: Bearer $GITLAB_TOKEN" )

        echo "$response" | jq -r '.message'
    else
        echo "Deletion cancelled."
    fi    
    
}


delete_gitlab_repo "$1" "$2"
