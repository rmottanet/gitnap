#!/usr/bin/env bash
set -euo pipefail

# Authentication and default settings
source "$GITNAP/utils/auth.sh"
source "$GITNAP/utils/endpoints.sh"
source "$GITNAP/utils/settings.sh"
source "$GITNAP/utils/format_pullrequest.sh"


function update_github_pullrequest() {
    local pr
    local REPO
    local OWNER
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
    OWNER="$3"
    
    # Verifica se o parâmetro foi fornecido
    if [[ -z "$OWNER" ]]; then
        # Se não foi fornecido, utiliza o padrão definido em auth.sh
        OWNER="$DEF_GH_OWNER"
    fi
        
    up_pr_title="$(format_pullrequest "title")"
    up_pr_body="$(format_pullrequest "body")"

    # Create the JSON payload for the repository
    payload='{"title":"'"$up_pr_title"'", "body":"'"$up_pr_body"'"}'

    #pr_url="$API_URL/$OWNER/$REPO/pulls"
    pr_endpoint="$(build_gh_endpoint "PR" "$OWNER" "$REPO")"
    endpoint="$pr_endpoint/$pr"
    
    # Create the repository using curl
    response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X PATCH "$endpoint" \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        -d "$payload" )

    # Check if there are erros
    echo "$response" | jq -r '.number // .message'
}

update_github_pullrequest "$1" "$2" "$3"
