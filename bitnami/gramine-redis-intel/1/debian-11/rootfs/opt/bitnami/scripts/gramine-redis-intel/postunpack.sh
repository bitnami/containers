#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Redis environment variables
. /opt/bitnami/scripts/gramine-redis-intel-env.sh

# Load libraries
#. /opt/bitnami/scripts/libgramineredis.sh
. /opt/bitnami/scripts/libfs.sh

ensure_dir_exists "$GRAMINE_KEY_DIR";
chmod -R g+rwX "$GRAMINE_KEY_DIR" "$REDIS_BASE_DIR"

# Install gramine library files
info "Relocating gramine python libs"
mv "${GRAMINE_BASE_DIR}/lib/python3.10/site-packages/graminelibos" /opt/bitnami/python/lib/python3.10/site-packages

# Install library dependencies
info "Installing gramine python dependencies"
/opt/bitnami/python/bin/pip install  click jinja2 toml protobuf===3.20.0 cryptography pyelftools

# Workaround for gramine scripts that looks for pyton on /usr/bin/python3
info "Creating python3 symbolic link"
ln -s /opt/bitnami/python/bin/python /usr/bin/python3
