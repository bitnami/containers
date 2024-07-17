#!/bin/bash
# Copyright VMware, Inc.
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
  [[ "$string" =~ $regex ]] && echo "${BASH_REMATCH[1]}"
}

log_pure() {
    stderr_print "$(date "+%T.%2N ")${*}"
}

log_pure "[notify pgbouncer] PGBOUNCER_PROMOTE_RELOAD_ENABLED=$PGBOUNCER_PROMOTE_RELOAD_ENABLED"
log_pure "[notify pgbouncer] PGBOUNCER_NODES=$PGBOUNCER_NODES"
log_pure "[notify pgbouncer] PGBOUNCER_DATABASE_INI=${PGBOUNCER_DATABASE_INI}"

if [[ "$PGBOUNCER_PROMOTE_RELOAD_ENABLED" = "true" ]]; then
  log_pure "[notify pgbouncer] start"

  # create pgbouncer database ini
  PGBOUNCER_DATABASE_INI_NEW="/tmp/pgbouncer.database.ini"

  # select conninfo
  query="SELECT conninfo FROM repmgr.nodes WHERE active = TRUE AND type='primary'"
  conninfo=$(PGPASSWORD="${REPMGR_PASSWORD}" psql -U ${REPMGR_USERNAME} -d ${REPMGR_DATABASE}  -A -t -c "${query}")
  log_pure "[notify pgbouncer] conninfo=$conninfo"

  echo -e "[databases]\n" > $PGBOUNCER_DATABASE_INI_NEW
  conninfo_host=$(match_first_regex "(host=[.0-9]+)" "$conninfo")
  conninfo_port=$(match_first_regex "(port=[0-9]+)" "$conninfo")
  echo -e "*=$conninfo_host $conninfo_port\n" >> $PGBOUNCER_DATABASE_INI_NEW

  log_pure "[notify pgbouncer] new configuration=$(cat $PGBOUNCER_DATABASE_INI_NEW)"

  # propagate file to pgbouncer nodes
  read -r -a NODES <<<"$(tr ',;' ' ' <<<"${PGBOUNCER_NODES}")"
  for NODE in "${NODES[@]}";
  do
      [[ "$NODE" =~ ^(([^:/?#]+):)?// ]] || NODE="tcp://${NODE}"
      HOST="$(parse_uri "$NODE" 'host')"
      PORT="$(parse_uri "$NODE" 'port')"

      log_pure "[notify pgbouncer] rsync configuration to node=${HOST}:${PORT}"
      rsync $PGBOUNCER_DATABASE_INI_NEW $HOST:$PGBOUNCER_DATABASE_INI

      log_pure "[notify pgbouncer] reload node=${HOST}:${PORT}"
      PGPASSWORD="${POSTGRESQL_PASSWORD}" psql -tc "reload" -h $HOST -p $PORT -U ${POSTGRESQL_USERNAME} pgbouncer
  done

  # clean up generated file
  rm $PGBOUNCER_DATABASE_INI_NEW

  log_pure "[notify pgbouncer] end"
fi
