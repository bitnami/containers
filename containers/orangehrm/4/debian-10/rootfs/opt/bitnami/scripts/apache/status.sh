#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libapache.sh
. /opt/bitnami/scripts/liblog.sh

# Load Apache environment variables
. /opt/bitnami/scripts/apache-env.sh

if is_apache_running; then
    info "apache is already running"
else
    info "apache is not running"
fi
