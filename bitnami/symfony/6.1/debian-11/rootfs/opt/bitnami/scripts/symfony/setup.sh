#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libsymfony.sh

# Load Symfony environment
. /opt/bitnami/scripts/symfony-env.sh

# Load MySQL Client environment for 'mysql_remote_execute' (after 'symfony-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/mysql-client-env.sh

# Ensure Symfony environment variables are valid
symfony_validate

# Ensure Symfony app is initialized
symfony_initialize

# Ensure all folders in /app are writable by the non-root "bitnami" user
chown -R bitnami:bitnami /app
