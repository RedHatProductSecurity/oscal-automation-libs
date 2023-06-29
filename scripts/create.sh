#!/bin/bash

# shellcheck disable=SC2128
SCRIPT_DIR="$(realpath "$(dirname "$BASH_SOURCE")")"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/logging.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/trestle.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/manage_ssps.sh"

function generate_ssp() {
    # shellcheck disable=SC2154
    run_log 0 "Generating Markdown for ${output}"
    # shellcheck disable=SC2154
    trestle author ssp-generate --compdefs "$comps" --profile "$profile" --output markdown/system-security-plans/"$output"
}


function assemble_ssp() {
    run_log 0 "Assembling to JSON for ${output}"
    trestle author ssp-assemble --name "$output" --compdefs "$comps" --markdown markdown/system-security-plans/"$output" --output "$output"
}

function var_check() {
    checkvars=("$@")
    for i in "${checkvars[@]}"; do
      if [ -z "${!i}" ]; then
        run_log 1 "Required variable $i not set"
      fi
    done
}

function create_ssp() {
    # Function requires the following variables
    vars=("comps" "output" "profile")
    var_check "${vars[@]}"

    run_log 0 "Creating new SSP ${output}"
    generate_ssp
    assemble_ssp
    update_ssp_index "$output" "$comps"
}