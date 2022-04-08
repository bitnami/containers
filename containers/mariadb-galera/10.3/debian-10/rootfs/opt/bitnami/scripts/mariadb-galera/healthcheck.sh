#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libmariadbgalera.sh

# Load MariaDB environment variables
. /opt/bitnami/scripts/mariadb-env.sh

mysql_healthcheck
