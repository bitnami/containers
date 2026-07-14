#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libmemcached.sh

# Load Memcached environment variables
. /opt/bitnami/scripts/memcached-env.sh

# Configure arguments with extra flags
args=("-u" "$MEMCACHED_DAEMON_USER" "-p" "$MEMCACHED_PORT_NUMBER" "-v")
[[ -n "$MEMCACHED_LISTEN_ADDRESS" ]] && args+=("-l" "$MEMCACHED_LISTEN_ADDRESS")
# SASL
[[ -f "$SASL_DB_FILE" ]] && args+=("-S")
# Memory configuration
[[ -n "$MEMCACHED_CACHE_SIZE" ]] && args+=("-m" "$MEMCACHED_CACHE_SIZE")
[[ -n "$MEMCACHED_MAX_CONNECTIONS" ]] && args+=("-c" "$MEMCACHED_MAX_CONNECTIONS")
[[ -n "$MEMCACHED_THREADS" ]] && args+=("-t" "$MEMCACHED_THREADS")
[[ -n "$MEMCACHED_MAX_ITEM_SIZE" ]] && args+=("-I" "$MEMCACHED_MAX_ITEM_SIZE")
# TLS
if [[ "${MEMCACHED_TLS_ENABLED:-no}" == "yes" ]]; then
    args+=("-Z")
    [[ -n "$MEMCACHED_TLS_CERT_FILE" ]] && args+=("-o" "ssl_chain_cert=${MEMCACHED_TLS_CERT_FILE}")
    [[ -n "$MEMCACHED_TLS_KEY_FILE" ]] && args+=("-o" "ssl_key=${MEMCACHED_TLS_KEY_FILE}")
    [[ -n "$MEMCACHED_TLS_CA_FILE" ]] && args+=("-o" "ssl_ca_cert=${MEMCACHED_TLS_CA_FILE}")
    [[ -n "$MEMCACHED_TLS_VERIFY_MODE" ]] && args+=("-o" "ssl_verify_mode=${MEMCACHED_TLS_VERIFY_MODE}")
fi
# Extra flags
read -r -a extra_flags <<<"$MEMCACHED_EXTRA_FLAGS"
[[ "${#extra_flags[@]}" -gt 0 ]] && args+=("${extra_flags[@]}")
args+=("$@")

info "** Starting Memcached **"
if am_i_root; then
    exec_as_user "$MEMCACHED_DAEMON_USER" memcached "${args[@]}"
else
    exec memcached "${args[@]}"
fi
