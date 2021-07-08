#!/bin/bash
#
# Executes custom Ruby init scripts

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

mysql_execute() {
    local -r sql_file="${1:?missing file}"
    local failure=0
    mysql_cmd=("mysql" "-h" "$MARIADB_HOST" "-P" "$MARIADB_PORT_NUMBER" "-u" "$MARIADB_ROOT_USER")
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
