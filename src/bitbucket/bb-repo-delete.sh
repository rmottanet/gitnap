#!/usr/bin/env bash
set -euo pipefail


# Construct basic authentication header
BITBUCKET_AUTH="Authorization: Basic $(echo -n "$BITBUCKET_USER:$BITBUCKET_APPWD" | base64)"


function delete_bitbucket_repo() {
    local repo
    local workspace
    local endpoint
    local response
    
    # Name of repository
    repo="$1"
    
    # Checks if the parameter was provided or use the name of the current directory
    if [[ -z "$repo" ]]; then
        repo=$(basename "$PWD")
    fi

    # Name of workspace
    workspace="$2"
    
    # Checks if the parameter was provided or use the default
    if [[ -z "$workspace" ]]; then
        workspace="$DEF_WORKSPACE"
    fi
        
    # Construct API Endpoint
    endpoint="https://api.bitbucket.org/2.0/repositories/$workspace/$repo"

    # Confirm deletion before proceeding
    echo "Are you sure you want to delete the repository '$repo' (y/N)?"
    read -r confirmation
    
    if [[ $confirmation =~ ^[Yy]$ ]]; then
        # Delete the repository
        response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X DELETE "$endpoint" \
        -H "$BITBUCKET_AUTH" )

        # Check if there are errors
        echo "$response" | jq -r '.error.message'
    else
        echo "Deletion cancelled."
    fi
    
    return 0
}


delete_bitbucket_repo "$1" "$2"
