#!/usr/bin/env bash
set -euo pipefail


function download_license() {
    local license_key
    local license_holder
    local repo_name
    local license_url
    
    # The key of the license template
    license_key="$1"

    # Checks if the parameter was provided
    if [[ -z "$license_key" ]]; then
        echo "Which is the license key?"
        curl -sSL "https://gitlab.com/api/v4/templates/licenses" | jq -r '.[].key'
        exit 1
    fi
    
    # The full-name of the copyright holder
    license_holder="Joe+Doe"
    
    # The copyrighted project name
    repo_name=$(basename "$PWD")
    
    # URL for Gitlab Licenses Templates
    license_url="https://gitlab.com/api/v4/templates/licenses/$license_key?project=$repo_name&fullname=$license_holder"
    
    # Download `LICENSE` file 
    curl --proto "=https" --tlsv1.2 -sSf -L "$license_url" | jq -r '.content' > LICENSE
}


download_license "$1"
