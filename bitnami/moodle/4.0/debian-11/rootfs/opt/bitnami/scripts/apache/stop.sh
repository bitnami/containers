#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libapache.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh

# Load Apache environment variables
. /opt/bitnami/scripts/apache-env.sh

error_code=0

if is_apache_running; then
    BITNAMI_QUIET=1 apache_stop
    if ! retry_while "is_apache_not_running"; then
        error "apache could not be stopped"
        error_code=1
    else
        info "apache stopped"
    fi
else
    info "apache is not running"
fi

exit "$error_code"
