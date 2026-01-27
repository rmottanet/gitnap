#!/usr/bin/env bash
set -euo pipefail


function download_gitignore() {
    local language_name
    local gitignore_url
    
    # Language name from parameter
    language_name="$1"
    
    # Checks if the parameter was provided
    if [[ -z "$language_name" ]]; then
        echo "Which is the language?"
        exit 1
    fi
    
    # Convert language name to title case
    language_name=$(echo "${language_name:0:1}" | tr '[:lower:]' '[:upper:]')"${language_name:1}"

    # URL for Gitlab Gitignore Templates
    gitignore_url="https://gitlab.com/api/v4/templates/gitignores/$language_name"
    
    # Download `.gitignore` file
    curl --proto "=https" --tlsv1.2 -sSf -L "$gitignore_url" | jq -r '.content' > .gitignore
}


download_gitignore "$1"
