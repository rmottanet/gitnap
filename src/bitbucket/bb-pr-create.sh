#!/usr/bin/env bash
set -euo pipefail

# Authentication and default settings
source "$GITNAP/utils/auth.sh"
source "$GITNAP/utils/endpoints.sh"
source "$GITNAP/utils/settings.sh"
source "$GITNAP/utils/format_pullrequest.sh"


function create_bitbucket_pullrequest() {
    local REPO
    local WORKSPACE
    local pr_title
    local pr_body
    local source_branch
    local target_branch
    local payload
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
        
    pr_title="$(format_pullrequest "title")"
    pr_body="$(format_pullrequest "body")"
    
    source_branch="$CURRENT_BRANCH"
    target_branch="$DEFAULT_BRANCH"

    # Create the JSON payload for the repository
    payload='{"title":"'"$pr_title"'", "description":"'"$pr_body"'",
        "source": { 
            "branch": { 
                "name": "'"$source_branch"'" 
            } },
        "destination": {
            "branch": { 
                "name": "'"$target_branch"'"
        } } }'

    # Construct URL endpoint
    endpoint="$(build_bb_endpoint "PR" "$WORKSPACE" "$REPO")"
    
    # Create the repository using curl
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X POST "$endpoint" \
        -H "$BITBUCKET_AUTH" \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d "$payload" )

    # Check if there are erros
    echo "$response" #| jq -r '.iid // .message'
}

create_bitbucket_pullrequest "$1" "$2" 
