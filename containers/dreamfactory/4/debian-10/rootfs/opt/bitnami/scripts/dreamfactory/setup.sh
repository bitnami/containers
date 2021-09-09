#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load DreamFactory environment
. /opt/bitnami/scripts/dreamfactory-env.sh

# Load PHP environment for 'PHP_BIN_DIR' (after 'dreamfactory-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load MySQL Client environment for 'mysql_remote_execute' (after 'dreamfactory-env.sh' so that MODULE is not set to a wrong value)
if [[ -f /opt/bitnami/scripts/mysql-client-env.sh ]]; then
    . /opt/bitnami/scripts/mysql-client-env.sh
elif [[ -f /opt/bitnami/scripts/mysql-env.sh ]]; then
    . /opt/bitnami/scripts/mysql-env.sh
elif [[ -f /opt/bitnami/scripts/mariadb-env.sh ]]; then
    . /opt/bitnami/scripts/mariadb-env.sh
fi

# Load PostgreSQL Client environment for 'postgresql_remote_execute' (after 'dreamfactory-env.sh' so that MODULE is not set to a wrong value)
if [[ -f /opt/bitnami/scripts/libpostgresqlclient.sh ]]; then
    . /opt/bitnami/scripts/postgresql-client-env.sh
elif [[ -f /opt/bitnami/scripts/libpostgresql.sh ]]; then
    . /opt/bitnami/scripts/postgresql-env.sh
fi

# Load MongoDB Client environment for 'mongodb_execute' (after 'dreamfactory-env.sh' so that MODULE is not set to a wrong value)
if [[ -f /opt/bitnami/scripts/libmongodbclient.sh ]]; then
    . /opt/bitnami/scripts/mongodb-client-env.sh
elif [[ -f /opt/bitnami/scripts/libmongodb.sh ]]; then
    . /opt/bitnami/scripts/mongodb-env.sh
fi

# Load libraries
. /opt/bitnami/scripts/libdreamfactory.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment (after DreamFactory environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure DreamFactory environment variables are valid
dreamfactory_validate

# Update web server configuration with runtime environment (needs to happen before the initialization)
web_server_update_app_configuration "dreamfactory"

# Ensure DreamFactory is initialized
dreamfactory_initialize
