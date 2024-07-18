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

log_pure "[notify pgbouncer] PGBOUNCER_PROMOTE_RELOAD_ENABLED=${PGBOUNCER_PROMOTE_RELOAD_ENABLED}"

if [[ "$PGBOUNCER_PROMOTE_RELOAD_ENABLED" = "true" ]]; then
  log_pure "[notify pgbouncer] start"
  log_pure "[notify pgbouncer] PGBOUNCER_NODES=${PGBOUNCER_NODES}"
  log_pure "[notify pgbouncer] PGBOUNCER_DATABASE_INI=${PGBOUNCER_DATABASE_INI}"

  # select conninfo
  query="SELECT conninfo FROM repmgr.nodes WHERE active = TRUE AND type='primary'"
  conninfo=$(PGPASSWORD="${REPMGR_PASSWORD}" psql -U "${REPMGR_USERNAME}" -d "${REPMGR_DATABASE}" -A -t -c "${query}")
  log_pure "[notify pgbouncer] conninfo=${conninfo}"

  echo -en "[databases]\n" >${PGBOUNCER_DATABASE_INI_TEMP}
  pg_primary_host=$(match_first_regex "(host=[.0-9]+)" "$conninfo")
  pg_primary_port=$(match_first_regex "(port=[0-9]+)" "$conninfo")
  echo -en "*=${pg_primary_host} ${pg_primary_port}\n" >>${PGBOUNCER_DATABASE_INI_TEMP}

  log_pure "[notify pgbouncer] new configuration=$(cat ${PGBOUNCER_DATABASE_INI_TEMP})"

  # propagate file to pgbouncer nodes
  read -r -a nodes <<<"$(tr ',;' ' ' <<<"${PGBOUNCER_NODES}")"
  for node in "${nodes[@]}"; do
    [[ "${node}" =~ ^(([^:/?#]+):)?// ]] || node="tcp://${node}"
    pgbouncer_host="$(parse_uri "${node}" "host")"
    pgbouncer_port="$(parse_uri "${node}" "port")"

    log_pure "[notify pgbouncer] rsync configuration to node=${pgbouncer_host}:${PGBOUNCER_CONTAINER_SSH_PORT}, user=${PGBOUNCER_CONTAINER_USERNAME}"
    rsync -e "sshpass -p ${PGBOUNCER_CONTAINER_PASSWORD} ssh -o StrictHostKeyChecking=no -p ${PGBOUNCER_CONTAINER_SSH_PORT}" "${PGBOUNCER_DATABASE_INI_TEMP}" \
      "${PGBOUNCER_CONTAINER_USERNAME}"@"${pgbouncer_host}":"${PGBOUNCER_DATABASE_INI}"

    log_pure "[notify pgbouncer] reload node=${pgbouncer_host}:${pgbouncer_port}"
    PGPASSWORD="${POSTGRESQL_PASSWORD}" psql -U "${POSTGRESQL_USERNAME}" -h "${pgbouncer_host}" -p "${pgbouncer_port}" -d pgbouncer -tc "reload"
  done

  # clean up generated file
  rm ${PGBOUNCER_DATABASE_INI_TEMP}

  log_pure "[notify pgbouncer] end"
fi
