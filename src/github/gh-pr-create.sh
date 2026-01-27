#!/usr/bin/env bash
set -euo pipefail

# Authentication and default settings
source "$GITNAP/utils/auth.sh"
source "$GITNAP/utils/endpoints.sh"
source "$GITNAP/utils/settings.sh"
source "$GITNAP/utils/format_pullrequest.sh"


function create_github_pullrequest() {
    local REPO
    local OWNER
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

    # Repo owner
    OWNER="$2"
    
    # Checks if the parameter was provided or use the default
    if [[ -z "$OWNER" ]]; then
        OWNER="$DEF_GH_OWNER"
    fi
        
    pr_title="$(format_pullrequest "title")"
    pr_body="$(format_pullrequest "body")"
    
    source_branch="$CURRENT_BRANCH"
    target_branch="$DEFAULT_BRANCH"

    # Create the JSON payload for the repository
    payload='{"title":"'"$pr_title"'", "body":"'"$pr_body"'",
        "head":"'"$source_branch"'","base":"'"$target_branch"'"}'

    # Construct URL endpoint
    endpoint="$(build_gh_endpoint "PR" "$OWNER" "$REPO")"
    
    # Create the repository using curl
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X POST "$endpoint" \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        -d "$payload" )

    # Check if there are erros
    echo "$response" | jq -r '.number // .message'
}

create_github_pullrequest "$1" "$2" 
