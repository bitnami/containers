#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Executes custom MySQL (.sql or .sql.gz) init scripts

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

MARIADB_HOST=${MARIADB_HOST:-$MOODLE_DATABASE_HOST}
MARIADB_PORT_NUMBER=${MARIADB_PORT_NUMBER:-$MOODLE_DATABASE_PORT_NUMBER}
MARIADB_ROOT_USER=${MARIADB_ROOT_USER:-$MOODLE_DATABASE_USER}
MARIADB_DATABASE=${MARIADB_DATABASE:-$MOODLE_DATABASE_NAME}
if [[ "${ALLOW_EMPTY_PASSWORD:-no}" != "yes" ]]; then
  MARIADB_ROOT_PASSWORD=${MARIADB_ROOT_PASSWORD:-$MOODLE_DATABASE_PASSWORD}
fi

mysql_execute() {
    local -r sql_file="${1:?missing file}"
    local failure=0
    mysql_cmd=("mysql" "-h" "$MARIADB_HOST" "-P" "$MARIADB_PORT_NUMBER" "-u" "$MARIADB_ROOT_USER" "-D" "${MARIADB_DATABASE}")
    if [[ "${ALLOW_EMPTY_PASSWORD:-no}" != "yes" ]]; then
        mysql_cmd+=("-p${MARIADB_ROOT_PASSWORD}")
    fi
    if [[ "$sql_file" == *".sql" ]]; then
        "${mysql_cmd[@]}" < "$sql_file" || failure=$?
    elif [[ "$sql_file" == *".sql.gz" ]]; then
        gunzip -c "$sql_file" | "${mysql_cmd[@]}" || failure=$?
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
        mysql_execute "$custom_init_script" || failure=1
        [[ "$failure" -ne 0 ]] && error "Failed to execute ${custom_init_script}"
    done
fi

exit "$failure"
