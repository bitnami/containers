#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Executes custom PostgreSQL (.sql or .sql.gz) init scripts

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries with logging functions
if [[ -f /opt/bitnami/base/functions ]]; then
    . /opt/bitnami/base/functions
else
    . /opt/bitnami/scripts/liblog.sh
fi

postgresql_execute() {
    local -r sql_file="${1:?missing file}"
    if [[ -n "$POSTGRESQL_PASSWORD" ]]; then
        export PGPASSWORD=$POSTGRESQL_PASSWORD
    fi
    local -a psql=("psql")
    if [[ -n "${POSTGRESQL_USER:-}" ]]; then
        psql+=("-U" "$POSTGRESQL_USER")
    else
        psql+=("-U" "$POSTGRESQL_USERNAME")
    fi
    if [[ "$sql_file" == *".sql" ]]; then
        "${psql[@]}" -f "$sql_file" || failure=$?
    elif [[ "$sql_file" == *".sql.gz" ]]; then
        gunzip -c "$sql_file" | "${psql[@]}" || failure=$?
    fi
    return "$failure"
}

# Loop through all input files passed via stdin
read -r -a custom_init_scripts <<< "$@"
failure=0
if [[ "${#custom_init_scripts[@]}" -gt 0 ]]; then
    for custom_init_script in "${custom_init_scripts[@]}"; do
        [[ ! "$custom_init_script" =~ ^.*(\.sql|\.sql\.gz)$ ]] && continue
        info "Executing ${custom_init_script}"
        postgresql_execute "$custom_init_script" || failure=1
        [[ "$failure" -ne 0 ]] && error "Failed to execute ${custom_init_script}"
    done
fi

exit "$failure"
