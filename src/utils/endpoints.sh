#!/usr/bin/env bash

# API base URL
BB_URL="https://api.bitbucket.org/2.0"
GH_URL="https://api.github.com"
GL_URL="https://gitlab.com/api/v4"

# API Repo Endpoints
BB_REPO_EP="repositories"
GH_REPO_EP="repos"
GL_REPO_EP="projects"


# Bitbucket endpoint builder
function build_bb_endpoint() {
    local route
    local owner
    local repo
    
    route="$1"
    owner="$2" # Workspace and Project key
    repo="$3"

    if [[ -z "$route" || -z "$owner" || -z "$repo" ]]; then
        echo "Error: route, owner, and repository are required for Bitbucket."
        exit 1
    fi

    # Endpoint selector
    case "$route" in
        PR)
            # Using $owner as workspace
            endpoint="$BB_URL/$BB_REPO_EP/$owner/$repo/pullrequests"
            ;;
        REPOS)
            endpoint="$BB_URL/$BB_REPO_EP/$owner/$repo"
            ;;
        # ... adicionar outras rotas específicas do Bitbucket
        *)
            echo "Choice route."
            ;;
    esac

    echo "$endpoint"
    
    return 0
}


# GitHub endpoint builder
function build_gh_endpoint() {
    local route
    local owner
    local repo
    
    route="$1"
    owner="$2"
    repo="$3"

    if [[ -z "$route" || -z "$owner" || -z "$repo" ]]; then
        echo "Error: route, owner, and repository are required for GitHub."
        exit 1
    fi

    # Endpoint selector
    case "$route" in
        PR)
            endpoint="$GH_URL/$GH_REPO_EP/$owner/$repo/pulls"
            ;;
        REPOS)
            endpoint="$GH_URL/$GH_REPO_EP/$owner/$repo"
            ;;
        # ... adicionar outras rotas específicas do GitHub
        *)
            echo "Choice route."
            ;;
    esac

    echo "$endpoint"
    
    return 0
}


# GitLab endpoint builder
function build_gl_endpoint() {
    local route
    local owner
    local repo
    local slash_encoded
    
    route="$1"
    owner="$2"
    repo="$3"
    slash_encoded="%2F"

    if [[ -z "$route" || -z "$owner" || -z "$repo" ]]; then
        echo "Error: route, owner, and repository are required for Gitlab."
        exit 1
    fi

    # Endpoint selector
    case "$route" in
        PR)
            endpoint="$GL_URL/$GL_REPO_EP/$owner$slash_encoded$repo/merge_requests"
            ;;
        REPOS)
            endpoint="$GL_URL/$GL_REPO_EP/$owner$slash_encoded$repo"
            ;;
        # ... adicionar outras rotas específicas do Gitlab
        *)
            echo "Choice route."
            ;;
    esac

    echo "$endpoint"
    
    return 0
}
