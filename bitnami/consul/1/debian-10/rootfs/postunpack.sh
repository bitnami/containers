#!/bin/bash

# Load libraries
. /libfs.sh
. /libos.sh
. /libconsul.sh

# Load Consul env. variables
eval "$(consul_env)"

for dir in ${CONSUL_CONF_DIR} ${CONSUL_DATA_DIR} ${CONSUL_LOG_DIR} ${CONSUL_TMP_DIR} ${CONSUL_SSL_DIR} ${CONSUL_EXTRA_DIR}; do
    ensure_dir_exists "${dir}"
    chmod -R g+rwX "${dir}"
done
