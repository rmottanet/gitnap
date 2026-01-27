#!/usr/bin/env bash
set -euo pipefail

# Authentication and default settings
source "$GITNAP/utils/auth.sh"
source "$GITNAP/utils/endpoints.sh"
source "$GITNAP/utils/settings.sh"
source "$GITNAP/utils/format_pullrequest.sh"


function create_bitbucket_pullrequest() {
    local pr
    local REPO
    local WORKSPACE
    local payload
    local pr_endpoint
    local endpoint
    local response
    
    # Pull Request number
    pr="$1"

    # Verifica se o parâmetro foi fornecido
    if [[ -z "$pr" ]]; then
        echo "Pull Request number is required."
        exit 1
    fi
        
    # Name of repository
    REPO="$2"
    
    # Verifica se o parâmetro foi fornecido
    if [[ -z "$REPO" ]]; then
        # Se não foi fornecido, utiliza o nome do diretório atual
        REPO=$(basename "$PWD")
    fi

    # Repo owner
    WORKSPACE="$3"
    
    # Verifica se o parâmetro foi fornecido
    if [[ -z "$WORKSPACE" ]]; then
        # Se não foi fornecido, utiliza o padrão definido em auth.sh
        WORKSPACE="$DEF_WORKSPACE"
    fi
        
    # Create the JSON payload for the repository
    payload='{
        "type": "merge",
        "message": "merging pullrequests",
        "close_source_branch": true,
        "merge_strategy": "squash"
    }'

    # Construct URL endpoint
    pr_endpoint="$(build_bb_endpoint "PR" "$WORKSPACE" "$REPO")"
    endpoint="$endpoint/$pr/merge"
    
    # Create the repository using curl
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X POST "$endpoint" \
        -H "$BITBUCKET_AUTH" \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d "$payload" )

    # Check if there are erros
    echo "$response" #| jq -r '.iid // .message'
    
    return 0
}

create_bitbucket_pullrequest "$1" "$2" "$3" 
