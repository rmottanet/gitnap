#!/usr/bin/env bash
set -euo pipefail


function delete_github_repo() {
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
        OWNER="$DEF_GH_OWNER"
    fi
        
    # Construct API Endpoint
    endpoint="https://api.github.com/repos/$OWNER/$REPO"
    
    # Confirm deletion before proceeding
    echo "Are you sure you want to delete the repository '$REPO' (y/N)?"
    read -r confirmation
    
    if [[ $confirmation =~ ^[Yy]$ ]]; then
        # Delete the repository using curl
        response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X DELETE "$endpoint" \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer $GITHUB_TOKEN" \
            -H "X-GitHub-Api-Version: 2022-11-28" )

        echo "$response" | jq -r '.message' 
    else
        echo "Deletion cancelled."
    fi
    
    return 0
}


delete_github_repo "$1" "$2"
