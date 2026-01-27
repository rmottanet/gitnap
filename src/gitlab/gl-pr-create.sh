#!/usr/bin/env bash
set -euo pipefail

# Authentication and default settings
source "$GITNAP/utils/auth.sh"
source "$GITNAP/utils/endpoints.sh"
source "$GITNAP/utils/settings.sh"
source "$GITNAP/utils/format_pullrequest.sh"


function create_gitlab_pullrequest() {
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
    
    # Verifica se o parâmetro foi fornecido
    if [[ -z "$REPO" ]]; then
        # Se não foi fornecido, utiliza o nome do diretório atual
        REPO=$(basename "$PWD")
    fi

    # Repo owner
    OWNER="$2"
    
    # Verifica se o parâmetro foi fornecido
    if [[ -z "$OWNER" ]]; then
        # Se não foi fornecido, utiliza o padrão definido em auth.sh
        OWNER="$DEF_GL_OWNER"
    fi
        
    pr_title="$(format_pullrequest "title")"
    pr_body="$(format_pullrequest "body")"
    
    source_branch="$CURRENT_BRANCH"
    target_branch="$DEFAULT_BRANCH"

    # Create the JSON payload for the repository
    payload='{"title":"'"$pr_title"'", "description":"'"$pr_body"'",
        "source_branch":"'"$source_branch"'","target_branch":"'"$target_branch"'",
        "remove_source_branch":"True", "squash":"True"}'

    # Construct the endpoint URL
    endpoint="$(build_gl_endpoint "PR" "$OWNER" "$REPO")"
    
    # Create the repository using curl
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X POST "$endpoint" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $GITLAB_TOKEN" \
        -d "$payload" )

    # Check if there are erros
    echo "$response" | jq -r '.iid // .message'
    
    return 0
}

create_gitlab_pullrequest "$1" "$2" 

