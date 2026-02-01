#!/usr/bin/env bash
set -euo pipefail


function delete_github_repo() {
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
        owner="$DEF_GH_OWNER"
    fi
        
    # Construct API Endpoint
    endpoint="https://api.github.com/repos/$owner/$repo"
    
    # Confirm deletion before proceeding
    echo "Are you sure you want to delete the repository '$repo' (y/N)?"
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
