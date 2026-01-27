#!/usr/bin/env bash
set -euo pipefail


# Construct basic authentication header
BITBUCKET_AUTH="Authorization: Basic $(echo -n "$BITBUCKET_USER:$BITBUCKET_APPWD" | base64)"


function create_bitbucket_repo() {
    local REPO
    local WORKSPACE
    local PROJECT
    local payload
    local endpoint
    local response
    
    # Name of repository
    REPO="$1"
    
    # Checks if the parameter was provided or use the name of the current directory
    if [[ -z "$REPO" ]]; then
        REPO=$(basename "$PWD")
    fi

    # Name of project
    PROJECT="$2"
    
    # Checks if the parameter was provided or use the default
    if [[ -z "$PROJECT" ]]; then
        PROJECT="$DEF_PROJECT"
    fi

    # Name of workspace
    WORKSPACE="$3"
    
    # Checks if the parameter was provided or use the default
    if [[ -z "$WORKSPACE" ]]; then
        WORKSPACE="$DEF_WORKSPACE"
    fi
    
    # Create the JSON payload for the repository
    payload='{"scm": "git", "is_private": true,
        "project": {
            "key": "'"$PROJECT"'"
        }}'

    # Construct the API Endpoint
    endpoint="https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO"
    
    # Create Bitbucket repository
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X POST "$endpoint" \
        -H "$BITBUCKET_AUTH" \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d "$payload" )

    # Check for successful creation
    echo "$response" | jq -r '.error.message // (.links.clone[] | select(.name == "ssh") | .href)'  
    
    return 0
}


create_bitbucket_repo "$1" "$2" "$3"
