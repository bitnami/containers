#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load SuiteCRM environment
. /opt/bitnami/scripts/suitecrm-env.sh

# Load libraries
. /opt/bitnami/scripts/libsuitecrm.sh
. /opt/bitnami/scripts/libfile.sh

host="${1:?missing host}"

suitecrm_conf_set "site_url" "http://${host}"
suitecrm_conf_set "host_name" "$host"
