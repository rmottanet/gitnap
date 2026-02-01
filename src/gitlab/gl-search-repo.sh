#!/usr/bin/env bash
set -euo pipefail


function search_gitlab_repo() {
    local query
    local endpoint
    local response
    local tmp_file

    # String to query
    query="$1"
    
    # Checks if the parameter was provided
    if [[ -z "$query" ]]; then
        echo "A query to search is necessary"
    fi

    # Construct API Endpoint
    endpoint="https://gitlab.com/api/v4/search?scope=projects&search=$query"

    # CURL and jq
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L "$endpoint" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $GITLAB_TOKEN" \
        | jq -r '.[] | "Name: \(.name), Description: \(.description), Web URL: \(.web_url)"' )

    # See in terminal
    tmp_file=$(mktemp)
    echo "$response" > "$tmp_file"
    less "$tmp_file"
    rm "$tmp_file"
    
    return 0
}

search_gitlab_repo "$1"
