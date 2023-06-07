#!/bin/bash

set -eu

####################################################
# Script: update.sh
# Description: It checks if there are any uncommited changes in a repo
#              with a specific pattern. It create a new branch and pull
#              request if there are changes.
# Usage: ./update.sh "My commit"
# Note: Useful for regenerating downstream OSCAL content
####################################################

# shellcheck disable=2128
SCRIPT_DIR="$(realpath "$(dirname "$BASH_SOURCE")")"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/logging.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/auto-commit-push.sh"

function main() {
  local COMMIT_TITLE="${1:-"Sync OSCAL Content"}"
  local COMMIT_BODY="chore: automatic content update"
  git checkout -b "autoupdate_$GITHUB_RUN_ID"

  if [ -z "$(git status --porcelain)" ]; then
    run_log 0 "Nothing to commit"
  else
    add_files '*.md *.json'
    if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
       run_log 0 "Nothing to commit"
    else
       local_commit "$COMMIT_BODY"
       create_branch_pull_request "$COMMIT_TITLE" "$COMMIT_BODY" "autoupdate_$GITHUB_RUN_ID" 
    fi
  fi
}

main "$@"
