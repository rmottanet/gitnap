#!/usr/bin/env bash
set -euo pipefail

# Authentication and default settings
source "$GITNAP/utils/auth.sh"
source "$GITNAP/utils/endpoints.sh"
source "$GITNAP/utils/settings.sh"
source "$GITNAP/utils/format_pullrequest.sh"


function update_bitbucket_pullrequest() {
    local pr    
    local REPO
    local PROJECT
    local up_pr_title
    local up_pr_body
    local source_branch
    local target_branch
    local payload
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
    PROJECT="$3"
    
    # Verifica se o parâmetro foi fornecido
    if [[ -z "$PROJECT" ]]; then
        # Se não foi fornecido, utiliza o padrão definido em auth.sh
        PROJECT="$DEF_PROJECT"
    fi
        
    up_pr_title="$(format_pullrequest "title")"
    up_pr_body="$(format_pullrequest "body")"

    # Create the JSON payload for the repository
    payload='{"title":"'"$up_pr_title"'", "description":"'"$up_pr_body"'",
        "source": { 
            "branch": { 
                "name": "'"$source_branch"'" 
            } },
        "destination": {
            "branch": { 
                "name": "'"$target_branch"'"
        } } }'

    # Construct URL endpoint
    #endpoint_url="$API_URL/projects/$PROJECT/repos/$REPO/pull-requests/$pr"

    pr_endpoint="$(build_bb_endpoint "PR" "$WORKSPACE" "$REPO")"
    endpoint="$pr_endpoint/$pr"
       
    # Create the repository using curl
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X PUT "$endpoint" \
        -H "$BITBUCKET_AUTH" \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d "$payload" )

    # Check if there are erros
    echo "$response" #| jq -r '.iid // .message'
}

update_bitbucket_pullrequest "$1" "$2" "$3"
