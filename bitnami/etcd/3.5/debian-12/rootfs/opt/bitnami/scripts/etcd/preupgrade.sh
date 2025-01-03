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
# Obtain endpoints to connect when running 'ectdctl' in a hook job
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   String
########################
etcdctl_job_endpoints() {
    local -a endpoints=()
    local host domain port count

    # get number of endpoints from initial cluster endpoints
    count="$(echo $ETCD_INITIAL_CLUSTER | awk -F, '{print NF}')"

    # This piece of code assumes this code is executed on a K8s environment
    # where etcd members are part of a statefulset that uses a headless service
    # to create a unique FQDN per member. Under these circumstances, the
    # ETCD_ADVERTISE_CLIENT_URLS env. variable is created as follows:
    #   SCHEME://POD_NAME.HEADLESS_SVC_DOMAIN:CLIENT_PORT,SCHEME://SVC_DOMAIN:SVC_CLIENT_PORT
    #
    # Assuming this, we can extract the HEADLESS_SVC_DOMAIN and obtain
    # every available endpoint
    read -r -a advertised_array <<<"$(tr ',;' ' ' <<<"$ETCD_ADVERTISE_CLIENT_URLS")"
    port="$(parse_uri "${advertised_array[0]}" "port")"

    for i in $(seq 0 $(($count - 1))); do
        pod_name="${MY_STS_NAME}-${i}"
        endpoints+=("${pod_name}.${ETCD_CLUSTER_DOMAIN}:${port:-2380}")
    done

    debug "etcdctl endpoints are ${endpoints[*]}"
    echo "${endpoints[*]}" | tr ' ' ','
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
    is_boolean_yes "$ETCD_ON_K8S" && extra_flags+=("--endpoints=$(etcdctl_job_endpoints)")
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