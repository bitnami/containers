#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami JanusGraph library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

# Aux function to ensure we copy files
# between filesystems atomically
atomic_copy() {
    local -r src="$1"
    local -r dst="$2"
    tmp_dst="$(dirname "$dst")/.$(basename "$dst").new"
    info "Installing $src to $dst ..."
    cp "$src" "$tmp_dst" && \
    mv "$tmp_dst" "$dst" && \
    info "$dst installed"
}

########################
# Install Cilium CNI plugin in the provided target root
# Globals:
#   CILIUM_BIN_DIR, CILIUM_CNI_BIN_DIR, HOST_CNI_BIN_DIR
# Arguments:
#   $1 - Target root directory
# Returns:
#   None
#########################
cilium_install_cni_plugin() {
    local -r target_root="${1:?target root is missing}"

    local -r target_dir="${target_root}${HOST_CNI_BIN_DIR}"
    ensure_dir_exists "$target_dir"

    atomic_copy "${CILIUM_CNI_BIN_DIR}/cilium-cni" "${target_dir}/cilium-cni"
    if [[ ! -f "${target_dir}/loopback" ]]; then
        atomic_copy "${CILIUM_BIN_DIR}/loopback" "${target_dir}/loopback" || true
    fi
}

########################
# Uninstall Cilium CNI plugin from the provided target root
# Globals:
#   HOST_CNI_BIN_DIR, HOST_CNI_CONF_DIR
# Arguments:
#   $1 - Target root directory
# Returns:
#   None
#########################
cilium_uninstall_cni_plugin() {
    local -r target_root="${1:?target root is missing}"

    local -r target_bin_dir="${target_root}${HOST_CNI_BIN_DIR}"
    local -r target_conf_dir="${target_root}${HOST_CNI_CONF_DIR}"

    # Remove Cilium CNI plugin binary and configuration files
    rm -f "${target_bin_dir}/cilium-cni"
    find "$target_conf_dir" -maxdepth 1 -type f \
        -name '*cilium*' -and \( \
        -name '*.conf' -or \
        -name '*.conflist' \
    \) -delete
}

########################
# Mount cgroup2 filesystem in the provided target root
# Globals:
#   CILIUM_BIN_DIR, HOST_CNI_BIN_DIR
# Arguments:
#   $1 - Target root directory
#   $2 - Target root cgroup
# Returns:
#   None
#########################
mount_cgroup2() {
    local -r target_root="${1:?target root is missing}"
    local -r target_root_cgroup="${2:?target root cgroup is missing}"

    local -r target_dir="${target_root}${HOST_CNI_BIN_DIR}"
    ensure_dir_exists "$target_dir"

    # The statically compiled Go binaries do not depend on system utilities
    # that can be missed on distros installed on the underlying host.
    atomic_copy "${CILIUM_BIN_DIR}/cilium-mount" "${target_dir}/cilium-mount"
    nsenter "--mount=${target_root}/proc/1/ns/mnt" "--cgroup=${target_root}/proc/1/ns/cgroup" "${HOST_CNI_BIN_DIR}/cilium-mount" "$target_root_cgroup"
    rm "${target_dir}/cilium-mount"
}

########################
# Apply sysctl overwrites in the provided target root
# Globals:
#   CILIUM_BIN_DIR, HOST_CNI_BIN_DIR
# Arguments:
#   $1 - Target root directory
# Returns:
#   None
#########################
sysctl_overwrites() {
    local -r target_root="${1:?target root is missing}"

    local -r target_dir="${target_root}${HOST_CNI_BIN_DIR}"
    ensure_dir_exists "$target_dir"

    # The statically compiled Go binaries do not depend on system utilities
    # that can be missed on distros installed on the underlying host.
    atomic_copy "${CILIUM_BIN_DIR}/cilium-sysctlfix" "${target_dir}/cilium-sysctlfix"
    nsenter "--mount=${target_root}/proc/1/ns/mnt" "${HOST_CNI_BIN_DIR}/cilium-sysctlfix"
    rm "${target_dir}/cilium-sysctlfix"
}

########################
# Generate bash completion for Cilium & Hubble
# Globals:
#   CILIUM_BIN_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
cilium_bash_completion() {
    echo ". /usr/share/bash-completion/bash_completion" >> /etc/bash.bashrc
    "${CILIUM_BIN_DIR}/cilium-dbg" completion bash > /usr/share/bash-completion/completions/cilium-dbg
    # TODO: UNCOMMENT THIS BLOCK ON NEXT RELEASE
    # cilium/hubble code was moved to cilium/cilium repo
    # See https://github.com/cilium/cilium/commit/5aec7f58af0e57f93d5fa65f6e84a5e45609aac0
    # "${CILIUM_BIN_DIR}/hubble" completion bash > /usr/share/bash-completion/completions/hubble
}

########################
# Check if kube-proxy is ready
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Whether kube-proxy is ready
########################
is_kube_proxy_ready() {
    local -r nft_regex='^:(KUBE-IPTABLES-HINT|KUBE-PROXY-CANARY)'
    local -r legacy_regex='^:KUBE-PROXY-CANARY'

    if iptables-nft-save -t mangle | grep -E "$nft_regex" || ip6tables-nft-save -t mangle | grep -E "$nft_regex"; then
        debug "Found kube-proxy iptables rules in nftables"
        true
    elif iptables-legacy-save | grep -E "$legacy_regex" || ip6tables-legacy-save | grep -E "$legacy_regex"; then
        debug "Found kube-proxy iptables rules in iptables"
        true
    else
        false
    fi
}
