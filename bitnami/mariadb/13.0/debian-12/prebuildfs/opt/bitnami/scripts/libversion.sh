#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Library for managing versions strings

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh

# Functions
########################
# Gets semantic version
# Arguments:
#   $1 - version: string to extract major.minor.patch
#   $2 - section: 1 to extract major, 2 to extract minor, 3 to extract patch
# Returns:
#   array with the major, minor and release
#########################
get_sematic_version () {
    local version="${1:?version is required}"
    local section="${2:?section is required}"
    local -a version_sections

    #Regex to parse versions: x.y.z
    local -r regex='([0-9]+)(\.([0-9]+)(\.([0-9]+))?)?'

    if [[ "$version" =~ $regex ]]; then
        local i=1
        local j=1
        local n=${#BASH_REMATCH[*]}

        while [[ $i -lt $n ]]; do
            if [[ -n "${BASH_REMATCH[$i]}" ]] && [[ "${BASH_REMATCH[$i]:0:1}" != '.' ]];  then
                version_sections[j]="${BASH_REMATCH[$i]}"
                ((j++))
            fi
            ((i++))
        done

        local number_regex='^[0-9]+$'
        if [[ "$section" =~ $number_regex ]] && (( section > 0 )) && (( section <= 3 )); then
             echo "${version_sections[$section]}"
             return
        else
            stderr_print "Section allowed values are: 1, 2, and 3"
            return 1
        fi
    fi
}

########################
# Compares two semantic versions
# Arguments:
#   $1 - version1: first version to compare
#   $2 - version2: second version to compare
# Returns:
#   -1 if version1 is less than version2
#   0 if version1 is equal to version2
#   1 if version1 is greater than version2
#########################
compare_semantic_versions() {
    local version1="${1:?version1 is required}"
    local version2="${2:?version2 is required}"
    local major1 major2 minor1 minor2 patch1 patch2

    major1="$(get_sematic_version "$version1" 1)"
    major2="$(get_sematic_version "$version2" 1)"
    minor1="$(get_sematic_version "$version1" 2)"
    minor2="$(get_sematic_version "$version2" 2)"
    patch1="$(get_sematic_version "$version1" 3)"
    patch2="$(get_sematic_version "$version2" 3)"

    if [[ "$major1" -eq "$major2" ]] && [[ "$minor1" -eq "$minor2" ]] && [[ "$patch1" -eq "$patch2" ]]; then
        echo "0"
    elif [[ "$major1" -lt "$major2" ]] ||
      { [[ "$major1" -eq "$major2" ]] && [[ "$minor1" -lt "$minor2" ]]; } ||
      { [[ "$major1" -eq "$major2" ]] && [[ "$minor1" -eq "$minor2" ]] && [[ "$patch1" -lt "$patch2" ]]; }; then
        echo "-1"
    else
        echo "1"
    fi
}
