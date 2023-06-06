#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$BASH_SOURCE")")"

source "$SCRIPT_DIR/logging.sh"
source "$SCRIPT_DIR/trestle.sh"

function generate_ssp() {
    run_log 0 "Generating Markdown for ${output}"
    trestle author ssp-generate --compdefs $comps --profile $profile --output markdown/system-security-plans/"$output"
}


function assemble_ssp() {
    run_log 0 "Assembling to JSON for ${output}"
    trestle author ssp-assemble --name "$output" --compdefs $comps --markdown markdown/system-security-plans/"$output" --output "$output"
}


function create_ssp() {
    run_log 0 "Creating new SSP ${output}"
    generate_ssp
    assemble_ssp
}