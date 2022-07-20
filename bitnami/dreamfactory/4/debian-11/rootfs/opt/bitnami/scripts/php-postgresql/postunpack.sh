#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libphp.sh

# Load PHP environment
. /opt/bitnami/scripts/php-env.sh

php_conf_set extension "pgsql"
php_conf_set extension "pdo_pgsql"
