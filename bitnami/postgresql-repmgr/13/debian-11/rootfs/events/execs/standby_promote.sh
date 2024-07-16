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

# CD change
debug "[notify pgbouncer] PGBOUNCER_PROMOTE_RELOAD_ENABLED=$PGBOUNCER_PROMOTE_RELOAD_ENABLED, PGBOUNCER_NODES=$PGBOUNCER_NODES, PGBOUNCER_DATABASE_INI=${PGBOUNCER_DATABASE_INI}"
if [[ "$PGBOUNCER_PROMOTE_RELOAD_ENABLED" = "true" ]]; then
  debug "[notify pgbouncer] start"

  # create pgbouncer database ini
  PGBOUNCER_DATABASE_INI_NEW="/tmp/pgbouncer.database.ini"

  echo -e "[databases]\n" > $PGBOUNCER_DATABASE_INI_NEW
  PGPASSWORD="${REPMGR_PASSWORD}" psql -d ${REPMGR_DATABASE} -U ${REPMGR_USERNAME} -t -A \
    -c "SELECT '${POSTGRESQL_DATABASE}= ' || conninfo \
        FROM repmgr.nodes \
        WHERE active = TRUE AND type='primary'" >> $PGBOUNCER_DATABASE_INI_NEW

  debug "[notify pgbouncer] new configuration=$(cat $PGBOUNCER_DATABASE_INI_NEW)"

  # propagate file to pgbouncer nodes
  read -r -a NODES <<<"$(tr ',;' ' ' <<<"${PGBOUNCER_NODES}")"
  for NODE in "${NODES[@]}";
  do
      [[ "$NODE" =~ ^(([^:/?#]+):)?// ]] || NODE="tcp://${NODE}"
      HOST="$(parse_uri "$NODE" 'host')"
      PORT="$(parse_uri "$NODE" 'port')"

      debug "[notify pgbouncer] rsync configuration to node=${HOST}:${PORT}"
      rsync $PGBOUNCER_DATABASE_INI_NEW $HOST:$PGBOUNCER_DATABASE_INI

      debug "[notify pgbouncer] reload node=${HOST}:${PORT}"
      PGPASSWORD="${POSTGRESQL_PASSWORD}" psql -tc "reload" -h $HOST -p $PORT -U ${POSTGRESQL_USERNAME} pgbouncer
  done

  # clean up generated file
  rm $PGBOUNCER_DATABASE_INI_NEW

  debug "[notify pgbouncer] end"
fi
