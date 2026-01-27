#!/usr/bin/env bash


function search_github_repo() {
    local QUERY
    local endpoint
    local response
    local tmp_file

    # String to query
    QUERY="$1"
    
    # Checks if the parameter was provided
    if [[ -z "$QUERY" ]]; then
        echo "A query to search is necessary"
    fi

    # Construct API Endpoint
    endpoint="https://api.github.com/search/repositories?q=$QUERY"

    response=$(curl --proto "=https" --tlsv1.2 -sSf -L "$endpoint" \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        | jq -r '.items[] | "Name: \(.name), Description: \(.description), Web URL: \(.html_url)"' )
    
    # See in terminal
    tmp_file=$(mktemp)
    echo "$response" > "$tmp_file"
    less "$tmp_file"
    rm "$tmp_file"

}

search_github_repo "$1"

