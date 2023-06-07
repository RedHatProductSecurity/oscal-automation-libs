#!/bin/bash

set -eu

####################################################
# Script: update-from-upstream.sh
# Description: Clones a git repository at a specific branch based on an argument input.
#              It copies if any files matching a pattern to the current directory
#              If the files have been updated and creates a branch and GitHub pull request.
# Usage: ./update-from-upstream.sh <branch> <repo_url> <patterns>
# Note: Useful for keeping upstream profiles and catalogs up to date
####################################################

# shellcheck disable=SC2128
SCRIPT_DIR="$(realpath "$(dirname "$BASH_SOURCE")")"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/logging.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/auto-commit-push.sh"


function main() {
    local BRANCH=$1
    local REPO_URL=$2
    local patterns=("${@:3}")

    local COMMIT_TITLE="Sync OSCAL Content"
    local COMMIT_BODY="chore: updates from upstream $REPO_URL"
    git checkout -b "autoupdate_$GITHUB_RUN_ID"

    tmpdir=$(mktemp -d)
    run_log 0 "Created $tmpdir"
    clone_repo "$BRANCH" "$REPO_URL" "$tmpdir"

    copy_files_with_pattern "$tmpdir" "." "${patterns[@]}" "$tmpdir"

    if [ -n "$(git status --porcelain)" ]; then
        
        add_files "${patterns[@]}"

        if [ -n "$(git status --untracked-files=no --porcelain)" ]; then
            local_commit "$COMMIT_BODY"
            create_branch_pull_request "$COMMIT_TITLE" "$COMMIT_BODY" "autoupdate_$GITHUB_RUN_ID"
        else
            run_log 0 "Nothing to commit."
        fi
    else
        run_log 0 "Nothing to commit."
    fi
}

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <branch> <repo_url> <patterns>"
    exit 1
fi
main "$@"