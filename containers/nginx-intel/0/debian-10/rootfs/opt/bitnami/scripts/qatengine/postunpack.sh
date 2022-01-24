#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/liblog.sh

# Symlink QAT_Engine files to the OpenSSL Engines folder
info "Adding Symlink to the QAT Engine files to the system OpenSSL engines folder"
ln -s /opt/bitnami/common/lib/engines-1.1/* /usr/lib/x86_64-linux-gnu/engines-1.1/
