#!/bin/bash

set -eu

####################################################
# Script: update-push.sh
# Description: It checks if there are any uncommited changes in a repo
#              with a specific pattern. It commit the changes to the specified
#              branch.
# Usage: ./update-push.sh "optional branch"
# Note: Useful for assembling Markdown into OSCAL JSON
####################################################

SCRIPT_DIR="$(realpath "$(dirname "$BASH_SOURCE")")"

source "$SCRIPT_DIR/logging.sh"
source "$SCRIPT_DIR/auto-commit-push.sh"

function main() {
    local BRANCH=$1
    local COMMIT_BODY="chore: automatic content update"

    if [ -n "$(git status --porcelain)" ]; then
        add_files '*.md *.json'

        if [ -n "$(git status --untracked-files=no --porcelain)" ]; then
            local_commit "$COMMIT_BODY"
            push_to_remote "$BRANCH"
        else
            run_log 0 "Nothing to commit."
        fi
    else
        run_log 0 "Nothing to commit."
    fi
}

main "$@"