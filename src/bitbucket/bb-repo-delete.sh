#!/usr/bin/env bash
set -euo pipefail


# Construct basic authentication header
BITBUCKET_AUTH="Authorization: Basic $(echo -n "$BITBUCKET_USER:$BITBUCKET_APPWD" | base64)"


function delete_bitbucket_repo() {
    local REPO
    local WORKSPACE
    local endpoint
    local response
    
    # Name of repository
    REPO="$1"
    
    # Checks if the parameter was provided or use the name of the current directory
    if [[ -z "$REPO" ]]; then
        REPO=$(basename "$PWD")
    fi

    # Name of workspace
    WORKSPACE="$2"
    
    # Checks if the parameter was provided or use the default
    if [[ -z "$WORKSPACE" ]]; then
        WORKSPACE="$DEF_WORKSPACE"
    fi
        
    # Construct API Endpoint
    endpoint="https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO"

    # Confirm deletion before proceeding
    echo "Are you sure you want to delete the repository '$REPO' (y/N)?"
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
    
}


delete_bitbucket_repo "$1" "$2"
