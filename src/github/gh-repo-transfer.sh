#!/usr/bin/env bash
set -eo pipefail

# Authentication and configuration
# The script follows the project architecture, locating the base directory to load utilities.
BASE_DIR=$(dirname "$(readlink -f "$0")")/..
source "${BASE_DIR}/utils/settings.sh"

# Ensures GITHUB_TOKEN is available, loading auth.sh if necessary
# This allows the script to run standalone
if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  if [[ -f "${BASE_DIR}/utils/auth.sh" ]]; then
    source "${BASE_DIR}/utils/auth.sh"
  fi
fi

# Function to transfer a repository on GitHub
function transfer_github_repo() {
  local target_repo
  local new_owner
  local endpoint
  local payload
  local response

  # Target repository in owner/repo format
  target_repo="$1"
  # New owner (user or organization) for the repository
  new_owner="$2"

  # Basic parameter validation
  if [[ -z "$target_repo" || -z "$new_owner" ]]; then
    echo "Usage: $0 <owner/repo> <novo_owner>"
    exit 1
  fi

  # Endpoint hardcoded
  # Doc: POST /repos/{owner}/{repo}/transfer
  # https://docs.github.com/en/rest/repos/repos?apiVersion=2026-03-10#transfer-a-repository
  endpoint="https://api.github.com/repos/$target_repo/transfer"
  
  # Creation of the JSON payload for the transfer
  payload=$(printf '{"new_owner":"%s"}' "$new_owner")

  # Performs the transfer using curl.
  response=$(curl --proto "=https" --tlsv1.2 -sSf -L -X POST "$endpoint" \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "X-GitHub-Api-Version: 2026-03-10" \
    -d "$payload")

  # Displays the response message or the repository name upon success.
  echo "$response" | jq -r '.message // .name'

  return 0
}

# Script execution with parameters passed via CLI
transfer_github_repo "$1" "$2"
