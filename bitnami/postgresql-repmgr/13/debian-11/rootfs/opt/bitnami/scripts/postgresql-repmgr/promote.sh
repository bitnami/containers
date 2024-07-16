#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/postgresql-env.sh

# promote standby to primary
PGPASSWORD="${REPMGR_PASSWORD}" repmgr standby promote -f "${REPMGR_CONF_FILE}" --log-to-file --log-level DEBUG --verbose

if [[ "$PGBOUNCER_PROMOTE_RELOAD_ENABLED" = "true" ]]; then
  # create pgbouncer database ini
  PGBOUNCER_DATABASE_INI="/opt/bitnami/pgbouncer/conf/pgbouncer.database.ini"
  PGBOUNCER_DATABASE_INI_NEW="/tmp/pgbouncer.database.ini"

  echo -e "[databases]\n" > $PGBOUNCER_DATABASE_INI_NEW
  PGPASSWORD="${REPMGR_PASSWORD}" psql -d ${REPMGR_DATABASE} -U ${REPMGR_USERNAME} -t -A \
    -c "SELECT '${POSTGRESQL_DATABASE}= ' || conninfo \
        FROM repmgr.nodes \
        WHERE active = TRUE AND type='primary'" >> $PGBOUNCER_DATABASE_INI_NEW

  # propagate file to pgbouncer nodes
  read -r -a nodes <<<"$(tr ',;' ' ' <<<"${PGBOUNCER_NODES}")"
  for NODE in "${nodes[@]}";
  do
      HOST="$(parse_uri "$NODE" 'host')"
      PORT="$(parse_uri "$NODE" 'port')"

      rsync $PGBOUNCER_DATABASE_INI_NEW $HOST:$PGBOUNCER_DATABASE_INI

      PGPASSWORD="${POSTGRESQL_PASSWORD}" psql -tc "reload" -h $HOST -p $PORT -U ${POSTGRESQL_USERNAME} pgbouncer
  done

  # clean up generated file
  rm $PGBOUNCER_DATABASE_INI_NEW
fi
