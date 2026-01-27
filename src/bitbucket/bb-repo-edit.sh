#!/usr/bin/env bash
set -euo pipefail


# Construct basic authentication header
BITBUCKET_AUTH="Authorization: Basic $(echo -n "$BITBUCKET_USER:$BITBUCKET_APPWD" | base64)"


function edit_bitbucket_repo() {
    local REPO
    local WORKSPACE
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
    
    # Name of workspace
    WORKSPACE="$3"
    
    # Checks if the parameter was provided or use the default
    if [[ -z "$WORKSPACE" ]]; then
        WORKSPACE="$DEF_WORKSPACE"
    fi

    # Create the JSON payload for the repository
    payload='{"description": "'"$new_description"'"}'
        
    # Construct API Endpoint
    endpoint="https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO"

    # Edit Bitbucket repository
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X PUT "$endpoint" \
        -H "$BITBUCKET_AUTH" \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d "$payload" )

    # Check if there are errors
    echo "$response" | jq -r '.error.message'
    
    return 0
}


edit_bitbucket_repo "$1" "$2" "$3"
