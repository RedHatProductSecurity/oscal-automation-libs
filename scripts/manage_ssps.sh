#!/bin/bash

# shellcheck disable=SC2128
SCRIPT_DIR="$(realpath "$(dirname "$BASH_SOURCE")")"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/logging.sh"

# Specify the default dictionary file
DEFAULT_SSP_INDEX="ssp_index.txt"

function new_index() {
    local file=${1:?file is required}
    header="##### This file is managed by automation. DO NOT EDIT. #####"

    # Write the header to the file (overwrite existing content)
    echo "$header" > "$file"
}

# Function to update the ssp index with with new associated
# component definitions. This allows for automated
# regeneratation and assembly of a particular set of
# ssps with compliance-trestle
function update_ssp_index() {
    local ssp="${1:?ssp is required}"
    local comps="${2:?comps is required}"
    local index_file="${3:-${DEFAULT_SSP_INDEX}}"

    # Declare the associative array
    declare -A index

    # Create the index file if it doesn't exist
    if [ ! -f "$index_file" ]; then
        new_index "$index_file"
    else 
        # Read the index file into the associative array
        while IFS=":" read -r key value; do
            index["$key"]=$value
        done < "$index_file"
    fi

    # Specify the key and value to check and update
    key=$ssp
    new_value=$comps

    # Check if the key exists and update the value if needed
    if [ "${index[$key]+exists}" ]; then
    if [ "${index[$key]}" != "$new_value" ]; then
        index["$key"]=$new_value
        rm "$index_file"
        new_index "$index_file"
        for key in "${!index[@]}"; do
            echo "$key:${index[$key]}" >> "$index_file"
        done
        run_log 0 "Value updated for key '$key'"
    else
        run_log 0 "Value for key '$key' is already up to date"
    fi
    else
    index["$key"]=$new_value
    rm "$index_file"
    new_index "$index_file"
    for key in "${!index[@]}"; do
        echo "$key:${index[$key]}" >> "$index_file"
    done
    run_log 0 "Key '$key' added to the index"
    fi
}


