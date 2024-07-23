#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

. "$REPMGR_EVENTS_DIR/execs/includes/anotate_event_processing.sh"
. "$REPMGR_EVENTS_DIR/execs/includes/lock_primary.sh"
. "$REPMGR_EVENTS_DIR/execs/includes/unlock_standby.sh"

# CD change notify pgbouncer
match_first_regex() {
  local -r regex="${1:?regex is missing}"
  local -r string="${2:?conninfo is missing}"
  [[ "${string}" =~ ${regex} ]] && echo "${BASH_REMATCH[1]}"
}

log_pure() {
  stderr_print "$(date "+%T.%2N ")${*}"
}

# param $1 - command
pgbouncer_command() {
  read -r -a nodes_psql <<<"$(tr ',;' ' ' <<<"${PGBOUNCER_NODES_PSQL}")"
  for node_psql in "${nodes_psql[@]}"; do
    [[ "${node_psql}" =~ ^(([^:/?#]+):)?// ]] || node_psql="tcp://${node_psql}"
    local pgbouncer_psql_host="$(parse_uri "${node_psql}" "host")"
    local pgbouncer_psql_port="$(parse_uri "${node_psql}" "port")"

    log_pure "[notify pgbouncer] $1 node=${pgbouncer_psql_host}:${pgbouncer_psql_port}"
    PGPASSWORD="${POSTGRESQL_PASSWORD}" psql -U "${POSTGRESQL_USERNAME}" -h "${pgbouncer_psql_host}" -p "${pgbouncer_psql_port}" -d pgbouncer -tc "$1"
  done
}

notify_pgbouncer() {
  log_pure "[notify pgbouncer] start"
  log_pure "[notify pgbouncer] PGBOUNCER_NODES_PSQL=${PGBOUNCER_NODES_PSQL}"
  log_pure "[notify pgbouncer] PGBOUNCER_NODES_SSH=${PGBOUNCER_NODES_SSH}"
  log_pure "[notify pgbouncer] PGBOUNCER_DATABASE_INI=${PGBOUNCER_DATABASE_INI}"
  log_pure "[notify pgbouncer] PGBOUNCER_DATABASES=${PGBOUNCER_DATABASES}"

  # select conninfo
  local -r query="SELECT conninfo FROM repmgr.nodes WHERE active = TRUE AND type='primary'"
  local -r conninfo=$(PGPASSWORD="${REPMGR_PASSWORD}" psql -U "${REPMGR_USERNAME}" -d "${REPMGR_DATABASE}" -A -t -c "${query}")
  log_pure "[notify pgbouncer] conninfo=${conninfo}"

  #kill connections to old primary
  read -r -a pgbouncer_databases <<<"$(tr ',;' ' ' <<<"${PGBOUNCER_DATABASES}")"
  for pgbouncer_database in "${pgbouncer_databases[@]}"; do
    pgbouncer_command "kill ${pgbouncer_database}"
  done

  echo -en "[databases]\n" >${PGBOUNCER_DATABASE_INI_TEMP}
  local -r pg_primary_host=$(match_first_regex "(host=[.0-9]+)" "$conninfo")
  local -r pg_primary_port=$(match_first_regex "(port=[0-9]+)" "$conninfo")
  echo -en "*=${pg_primary_host} ${pg_primary_port}\n" >>${PGBOUNCER_DATABASE_INI_TEMP}

  log_pure "[notify pgbouncer] new configuration=$(cat ${PGBOUNCER_DATABASE_INI_TEMP})"

  # send file to pgbouncer nodes
  read -r -a nodes_ssh <<<"$(tr ',;' ' ' <<<"${PGBOUNCER_NODES_SSH}")"
  for node_ssh in "${nodes_ssh[@]}"; do
    [[ "${node_ssh}" =~ ^(([^:/?#]+):)?// ]] || node_ssh="tcp://${node_ssh}"
    local pgbouncer_ssh_host="$(parse_uri "${node_ssh}" "host")"
    local pgbouncer_ssh_port="$(parse_uri "${node_ssh}" "port")"

    log_pure "[notify pgbouncer] rsync configuration to node=${pgbouncer_ssh_host}:${pgbouncer_ssh_port}, user=${PGBOUNCER_CONTAINER_USERNAME}"
    rsync -e "sshpass -p ${PGBOUNCER_CONTAINER_PASSWORD} ssh -o StrictHostKeyChecking=no -p ${pgbouncer_ssh_port}" "${PGBOUNCER_DATABASE_INI_TEMP}" \
      "${PGBOUNCER_CONTAINER_USERNAME}"@"${pgbouncer_ssh_host}":"${PGBOUNCER_DATABASE_INI}"
  done

  # reload pgbouncer
  pgbouncer_command reload

  # resume pgbouncer connections
  for pgbouncer_database in "${pgbouncer_databases[@]}"; do
    pgbouncer_command "resume ${pgbouncer_database}"
  done

  # clean up generated file
  rm ${PGBOUNCER_DATABASE_INI_TEMP}

  log_pure "[notify pgbouncer] end"
}

log_pure "[notify pgbouncer] PGBOUNCER_PROMOTE_RELOAD_ENABLED=${PGBOUNCER_PROMOTE_RELOAD_ENABLED}"
if [[ "$PGBOUNCER_PROMOTE_RELOAD_ENABLED" = "true" ]]; then
  notify_pgbouncer
fi
