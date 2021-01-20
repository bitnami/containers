#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libapache.sh

# Load Apache environment variables
. /opt/bitnami/scripts/apache-env.sh

/opt/bitnami/scripts/apache/stop.sh
/opt/bitnami/scripts/apache/start.sh
