#!/usr/bin/env bash

# This section loads configuration files needed to set environment variables
# such as GITHUB_TOKEN. If these variables are already exported globally in the shell, 
# the files below can remain commented out. Otherwise, uncomment the appropriate 
# file(s) as needed. This particular script only needs GITHUB_TOKEN to function properly.

# source "$GITNAP/utils/auth.sh"
# source "$GITNAP/utils/settings.sh"


function list_github_repo() {
    local endpoint
    local response
    local tmp_file
    
    endpoint="https://api.github.com/user/repos?per_page=100"
    tmp_file=$(mktemp)
    
    # Get all repositories
    while [[ "$endpoint" ]]; do
        repos=$(curl --proto "=https" --tlsv1.2 -sSf -L -H "Authorization: token $GITHUB_TOKEN" "$endpoint")
        echo "$repos" >> "$tmp_file"
        
        # Iterate through each repository in the response
        for repo_url in $(echo "$repos" | jq -r '.[].url'); do
            response=$(curl --proto "=https" --tlsv1.2 -sSf -L -H "Authorization: token $GITHUB_TOKEN" "$repo_url")
            echo "$response" >> "$tmp_file"
        done
        
        # Check for more pages
        endpoint=$(curl --proto "=https" --tlsv1.2 -sSf -L -I -H "Authorization: token $GITHUB_TOKEN" "$endpoint" | grep -i '^link:' | sed -n 's/.*<\(.*\)>; rel="next".*/\1/p')
    done
    
    less "$tmp_file"                                    
    rm "$tmp_file"
    
    return 0
}

list_github_repo
