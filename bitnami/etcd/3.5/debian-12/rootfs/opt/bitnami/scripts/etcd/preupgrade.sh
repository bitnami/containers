#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o pipefail
set -o nounset

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libetcd.sh

# Load etcd environment settings
. /opt/bitnami/scripts/etcd-env.sh

########################
# Return a comma separated list of <host>:<port> for each endpoint
# based on "initial-cluster" flag value
# ref: https://etcd.io/docs/latest/op-guide/clustering/#static
# Globals:
#   ETCD_INITIAL_CLUSTER 
# Arguments:
#   None
# Returns:
#   String
########################
endpoints_as_host_port() {
    echo "$ETCD_INITIAL_CLUSTER" | tr -s ',' '\n' | awk -F '//' '{print $2}' | tr -s '\n' ',' | sed 's/,$//'
}

# Remove members that are not listed in ETCD_INITIAL_CLUSTER
# from the cluster before running Helm upgrades that potentially scale
# down the etcd cluster

read -r -a extra_flags <<<"$(etcdctl_auth_flags)"
is_boolean_yes "$ETCD_ON_K8S" && extra_flags+=("--endpoints=$(endpoints_as_host_port)")
debug "Listing members"
if ! current="$(etcdctl member list "${extra_flags[@]}" --write-out simple | awk -F ", " '{print $3 ":" $1}')"; then
    error "Unable to list members, are all members healthy?"
    exit 1
fi
info "Current cluster members are: $(echo "$current" | awk -F: '{print $1}' | tr -s '\n' ',' | sed 's/,$//g')"

expected="$(echo "$ETCD_INITIAL_CLUSTER" | tr -s ',' '\n' | awk -F= '{print $1}')"
info "Expected cluster members are: $(echo "$expected" | tr -s '\n' ',' | sed 's/,$//g')"
read -r -a obsolete_members <<<"$(comm -23 <(echo "$current" | awk -F: '{print $1}' | sort) <(echo "$expected" | sort) | tr -s '\n' ' ')"
if [[ "${#obsolete_members[@]}" -eq 0 ]]; then
    info "No obsolete members to remove."
else
    for member in "${obsolete_members[@]}"; do
        info "Removing obsolete member $member"
        etcdctl member remove "${extra_flags[@]}" "$(echo "$current" | grep "$member" | awk -F: '{print $2}')"
    done
fi
info "Pre-upgrade checks completed!"
