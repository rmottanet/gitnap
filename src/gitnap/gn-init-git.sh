#!/usr/bin/env bash
set -euo pipefail

source "$GITNAP/utils/down_gitignore.sh"
source "$GITNAP/utils/down_license.sh"

# Sets up a new Git project with optional .gitignore and license.
function initialize_git_repo() {
    local repo
    
    # Get current working directory
    repo=$(basename "$PWD")
    
    # Initialize Git repository
    git init --initial-branch=main
    
    # Check for existing README.md file
    if [[ ! -f "README.md" ]]; then
        echo "# $repo" > README.md
    fi
    
    git add README.md
    
    # Handle optional language parameter
    if [[ -n "$1" ]]; then
        # Language name from parameter
        language="$1"
        download_gitignore "$language"
        git add .gitignore
    fi
    
    # Handle optional license parameter
    if [[ -n "$2" ]]; then
        # License type from parameter
        license="$2"
        download_license "$license"
        git add LICENSE
    fi
    
    git commit -m "Initializing"
    
    # TODO: select and set remote to push

    
    return 0
}


initialize_git_repo "$1" "$2"
