#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091
set -eu

. /opt/bitnami/scripts/libpostgresql.sh
. /opt/bitnami/scripts/postgresql-env.sh

##
## Script adapted from upstream migrate.sh
## https://github.com/supabase/postgres/blob/develop/migrations/db/migrate.sh
##

export PGDATABASE="${POSTGRESQL_DB:-postgres}"
export PGHOST="${POSTGRES_HOST:-localhost}"
export PGPORT="${POSTGRESQL_PORT_NUMBER:-5432}"
if [[ "$POSTGRESQL_USERNAME" = "postgres" ]]; then
    export PGPASSWORD="${POSTGRESQL_PASSWORD:-}"
else
    export PGPASSWORD="${POSTGRESQL_POSTGRES_PASSWORD:-}"
fi

for sql in /opt/bitnami/supabase-postgres/migrations/*.sql; do
    echo "$0: running $sql"
    psql -v ON_ERROR_STOP=1 --no-password --no-psqlrc -U postgres -f "$sql"
done

for sql in /opt/bitnami/supabase-postgres/migrations/db/init-scripts/*.sql; do
    echo "$0: running $sql"
    psql -v ON_ERROR_STOP=1 --no-password --no-psqlrc -U postgres -f "$sql"
done
echo "Configuring supabase_admin user"
psql -v ON_ERROR_STOP=1 --no-password --no-psqlrc -U postgres -c "ALTER USER supabase_admin WITH PASSWORD '$PGPASSWORD'"
# run migrations as super user - postgres user demoted in post-setup
for sql in /opt/bitnami/supabase-postgres/migrations/db/migrations/*.sql; do
    echo "$0: running $sql"
    psql -v ON_ERROR_STOP=1 --no-password --no-psqlrc -U supabase_admin -f "$sql"
done

# once done with everything, reset stats from init
psql -v ON_ERROR_STOP=1 --no-password --no-psqlrc -U supabase_admin -c 'SELECT extensions.pg_stat_statements_reset(); SELECT pg_stat_reset();' || true
