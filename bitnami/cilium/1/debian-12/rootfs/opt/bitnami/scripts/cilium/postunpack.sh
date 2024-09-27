#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libcilium.sh
. /opt/bitnami/scripts/libos.sh

# Load Cilium environment variables
. /opt/bitnami/scripts/cilium-env.sh

# Photon does not provide the bash-completion package
if [[ "$(get_os_metadata --id)" != "photon" ]]; then
    # Generate bash completion for Cilium & Hubble
    cilium_bash_completion
fi

# Ensure non-root user has write permissions on a set of directories
mv "${CILIUM_LIB_DIR}/cilium/bpf" "${CILIUM_LIB_DIR}/bpf" && rmdir "${CILIUM_LIB_DIR}/cilium"
for dir in "$CILIUM_LIB_DIR" "$CILIUM_RUN_DIR" ; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done
# Add symlinks to the default paths to make a similar UX as the upstream Cilium configuration
# https://github.com/cilium/cilium/blob/main/pkg/defaults/defaults.go
ln -s "$CILIUM_LIB_DIR" "/var/lib/cilium"
ln -s "$CILIUM_RUN_DIR" "/var/run/cilium"

ALTERNATIVES_CMD=update-alternatives
if [ -x /usr/bin/alternatives ] || [ -x /usr/sbin/alternatives ]; then
    # Fedora/SUSE style alternatives
    ALTERNATIVES_CMD=alternatives
fi

# Point the iptables binaries to iptables-wrapper
if "$ALTERNATIVES_CMD" 2>&1 | grep follower; then
    # New version of command which uses follower
    "$ALTERNATIVES_CMD" \
        --install /usr/sbin/iptables iptables /usr/sbin/iptables-wrapper 100 \
        --follower /usr/sbin/iptables-restore iptables-restore /usr/sbin/iptables-wrapper \
        --follower /usr/sbin/iptables-save iptables-save /usr/sbin/iptables-wrapper
    "$ALTERNATIVES_CMD" \
        --install /usr/sbin/ip6tables ip6tables /usr/sbin/iptables-wrapper 100 \
        --follower /usr/sbin/ip6tables-restore ip6tables-restore /usr/sbin/iptables-wrapper \
        --follower /usr/sbin/ip6tables-save ip6tables-save /usr/sbin/iptables-wrapper
else
    # Old version of command, which uses slave
    "$ALTERNATIVES_CMD" \
        --install /usr/sbin/iptables iptables /usr/sbin/iptables-wrapper 100 \
        --slave /usr/sbin/iptables-restore iptables-restore /usr/sbin/iptables-wrapper \
        --slave /usr/sbin/iptables-save iptables-save /usr/sbin/iptables-wrapper
    "$ALTERNATIVES_CMD" \
        --install /usr/sbin/ip6tables ip6tables /usr/sbin/iptables-wrapper 100 \
        --slave /usr/sbin/ip6tables-restore ip6tables-restore /usr/sbin/iptables-wrapper \
        --slave /usr/sbin/ip6tables-save ip6tables-save /usr/sbin/iptables-wrapper
fi
