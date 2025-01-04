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
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   String
########################
endpoints_as_host_port() {
    echo $ETCD_INITIAL_CLUSTER | tr -s ',' '\n' | awk -F '//' '{print $2}' | tr -s '\n' ',' | sed 's/,$//'
}

########################
# Remove members that are not named in ETCD_INITIAL_CLUSTER
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   None
#########################
remove_members() {
    local -a extra_flags current expected
    
    read -r -a extra_flags <<<"$(etcdctl_auth_flags)"
    is_boolean_yes "$ETCD_ON_K8S" && extra_flags+=("--endpoints=$(endpoints_as_host_port)")
    debug "Listing members"
    current="$(etcdctl member list ${extra_flags[@]} --write-out simple | awk -F ", " '{print $1 "," $3}')"
    if [ $? -ne 0 ]; then
        debug "Error listing members, is this a new cluster?"
        return 0
    fi
    info "Current cluster members are: $(echo "${current[@]}" | awk -F, '{print $2}' | tr -s '\n' ',' | sed 's/,$//g')"

    expected="$(echo $ETCD_INITIAL_CLUSTER | sed 's/,/\n/g' | awk -F= '{print $1}')"
    info "Expected cluster members are: $(IFS= echo "${expected[@]}" | tr -s '\n' ', ' | sed 's/,$//g')"

    for member in $(comm -23 <(echo "${current[@]}" | awk -F, '{print $2}' | sort) <(echo "${expected[@]}" | sort)); do
        info "Removing obsolete member $member"
        etcdctl member remove ${extra_flags[@]} $(echo "${current[@]}" | grep "$member" | awk -F, '{print $1}')
    done
}

remove_members