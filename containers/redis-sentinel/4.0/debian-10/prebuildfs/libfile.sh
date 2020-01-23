#!/bin/bash
#
# Library for managing files

# Functions

########################
# Ensure a line exists in the file by replacing a matching line.
# Arguments:
#   $1 - filename
#   $2 - line
#   $3 - match
# Returns:
#   None
#########################
file_contains_line() {
    local filename="${1:?filename is required}"
    local line="${2:?line is required}"
    local match="${3:?match is required}"

    sed --in-place "s/^$match\$/$line/" "$filename"
}
