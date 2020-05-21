#!/bin/bash
#
# Post-init script to execute SQL files with MySQL client

# shellcheck disable=SC1091

# set -o xtrace # Uncomment this line for debugging purposes

. /opt/bitnami/base/functions

readonly f="${1:?missing SQL file}"
failure=0

if [[ "$f" =~ ^.*(\.sql|\.sql\.gz)$ ]]; then
    info "Executing $f"
    mysql_cmd=( mysql -h "$MARIADB_HOST" -P "$MARIADB_PORT_NUMBER" -u "$MARIADB_ROOT_USER" )
    if [[ "${ALLOW_EMPTY_PASSWORD:-no}" != "yes" ]]; then
        mysql_cmd+=( -p"$MARIADB_ROOT_PASSWORD" )
    fi
    if [[ "$f" == *".sql" ]]; then
        "${mysql_cmd[@]}" < "$f" || failure=$?
    elif [[ "$f" == *".sql.gz" ]]; then
        gunzip -c "$f" | "${mysql_cmd[@]}" || failure=$?
    fi
fi
if [[ "$failure" -ne 0 ]]; then
    error "Failed to execute ${f}"
    exit "$failure"
fi
