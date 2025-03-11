#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami etcd library

# shellcheck disable=SC1090,SC1091,SC2119,SC2120

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libservice.sh

# Functions

########################
# Write a configuration setting value
# Globals:
#   ETCD_CONF_FILE
# Arguments:
#   $1 - key
#   $2 - value
#   $3 - YAML type (string, int or bool)
# Returns:
#   None
#########################
etcd_conf_write() {
    local -r key="${1:?Missing key}"
    local -r value="${2:-}"
    local -r type="${3:-string}"
    local -r tempfile=$(mktemp)

    [[ -z "$value" ]] && return
    [[ ! -f "$ETCD_CONF_FILE" ]] && touch "$ETCD_CONF_FILE"
    case "$type" in
    string)
        yq eval "(.${key}) |= \"${value}\"" "$ETCD_CONF_FILE" >"$tempfile"
        ;;
    bool)
        yq eval "(.${key}) |= (\"${value}\" | test(\"true\"))" "$ETCD_CONF_FILE" >"$tempfile"
        ;;
    raw)
        yq eval "(.${key}) |= ${value}" "$ETCD_CONF_FILE" >"$tempfile"
        ;;
    *)
        error "Type unknown: ${type}"
        return 1
        ;;
    esac
    cp "$tempfile" "$ETCD_CONF_FILE"
}

########################
# Creates etcd configuration file from environment variables
# Globals:
#   ETCD_CFG_*
# Arguments:
#   None
# Returns:
#   None
#########################
etcd_setup_from_environment_variables() {
    ## Except for Client and Peer TLS configuration,
    ## all etcd settings consists of ETCD_FLAG_NAME
    ## transformed into flag-name and configured under the yaml config root.
    local -a client_tls_values=(
        "ETCD_CFG_CERT_FILE"
        "ETCD_CFG_KEY_FILE"
        "ETCD_CFG_CLIENT_CERT_AUTH"
        "ETCD_CFG_TRUSTED_CA_FILE"
        "ETCD_CFG_AUTO_TLS"
        "ETCD_CFG_CA_FILE"
    )
    info "Generating etcd config file using env variables"
    # Map environment variables to config properties for etcd-env.sh
    for var in "${!ETCD_CFG_@}"; do
        value="${!var:-}"
        if [[ -n "$value" ]]; then
            type="string"
            # Detect if value is digit or bool
            if [[ "$value" =~ ^[+-]?[0-9]+([.][0-9]+)?$ || "$value" =~ ^(true|false)$ ]]; then
                type="raw"
            fi
            if [[ ${client_tls_values[*]} =~ ${var} ]]; then
                key="$(echo "$var" | sed -e 's/^ETCD_CFG_//g' -e 's/_/-/g' | tr '[:upper:]' '[:lower:]')"
                etcd_conf_write "client-transport-security.${key}" "$value" "$type"
            elif [[ "$var" =~ "ETCD_CFG_CLIENT_" ]]; then
                key="$(echo "$var" | sed -e 's/^ETCD_CFG_CLIENT_//g' -e 's/_/-/g' | tr '[:upper:]' '[:lower:]')"
                etcd_conf_write "client-transport-security.${key}" "$value" "$type"
            elif [[ "$var" =~ "ETCD_CFG_PEER_" ]]; then
                key="$(echo "$var" | sed -e 's/^ETCD_CFG_PEER_//g' -e 's/_/-/g' | tr '[:upper:]' '[:lower:]')"
                etcd_conf_write "peer-transport-security.${key}" "$value" "$type"
            else
                # shellcheck disable=SC2001
                key="$(echo "$var" | sed -e 's/^ETCD_CFG_//g' -e 's/_/-/g' | tr '[:upper:]' '[:lower:]')"
                etcd_conf_write "$key" "$value" "$type"
            fi
        fi
    done
    if am_i_root && [[ -f "$ETCD_CONF_FILE" ]] ; then
        chown "$ETCD_DAEMON_USER" "$ETCD_CONF_FILE"
    fi
}

########################
# Validate settings in ETCD_* environment variables
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   None
#########################
etcd_validate() {
    info "Validating settings in ETCD_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    if is_boolean_yes "$ALLOW_NONE_AUTHENTICATION"; then
        warn "You set the environment variable ALLOW_NONE_AUTHENTICATION=${ALLOW_NONE_AUTHENTICATION}. For safety reasons, do not use this flag in a production environment."
    else
        is_empty_value "$ETCD_ROOT_PASSWORD" && print_validation_error "The ETCD_ROOT_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_NONE_AUTHENTICATION=yes to allow a blank password. This is only recommended for development environments."
    fi
    if is_boolean_yes "$ETCD_START_FROM_SNAPSHOT" && [[ ! -f "${ETCD_INIT_SNAPSHOTS_DIR}/${ETCD_INIT_SNAPSHOT_FILENAME}" ]]; then
        print_validation_error "You are trying to initialize etcd from a snapshot, but no snapshot was found. Set the environment variable ETCD_INIT_SNAPSHOT_FILENAME with the snapshot filename and mount it at '${ETCD_INIT_SNAPSHOTS_DIR}' directory."
    fi

    [[ "$error_code" -eq 0 ]] || return "$error_code"
}

########################
# Check if etcd is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_etcd_running() {
    local pid
    pid="$(pgrep -f "^etcd" || true)"

    # etcd does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    if [[ -n "${ETCD_PID_FILE:-}" ]]; then
        echo "$pid" >"$ETCD_PID_FILE"
    fi

    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if etcd is running
# Globals:
#   ETCD_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether etcd is not running
########################
is_etcd_not_running() {
    ! is_etcd_running
}

########################
# Stop etcd
# Arguments:
#   None
# Returns:
#   None
#########################
etcd_stop() {
    local pid
    ! is_etcd_running && return

    info "Stopping etcd"
    # Ensure process matches etcd binary with or without options
    pid="$(pgrep -f "^etcd")"
    local counter=10
    kill "$pid"
    while [[ "$counter" -ne 0 ]] && is_service_running "$pid"; do
        sleep 1
        counter=$((counter - 1))
    done
}

########################
# Start etcd in background
# Arguments:
#   None
# Returns:
#   None
#########################
etcd_start_bg() {
    is_etcd_running && return

    info "Starting etcd in background"
    local start_command=("etcd")
    am_i_root && start_command=("run_as_user" "$ETCD_DAEMON_USER" "${start_command[@]}")
    [[ -f "$ETCD_CONF_FILE" ]] && start_command+=("--config-file" "$ETCD_CONF_FILE")
    debug_execute "${start_command[@]}" &
    sleep 3
}

########################
# Obtain endpoints to connect when running 'ectdctl'
# Globals:
#   ETCD_*
# Arguments:
#   $1 - exclude current member from the list (default: false)
# Returns:
#   String
########################
etcdctl_get_endpoints() {
    local only_others=${1:-false}
    local -a endpoints=()
    local host domain port

    hostname_has_ips() {
        local hostname="${1:?hostname is required}"
        [[ "$(getent ahosts "$hostname")" != "" ]] && return 0
        return 1
    }

    # This piece of code assumes this code is executed on a K8s environment
    # where etcd members are part of a statefulset that uses a headless service
    # to create a unique FQDN per member. Under these circumstances, the
    # ETCD_ADVERTISE_CLIENT_URLS env. variable is created as follows:
    #   SCHEME://POD_NAME.HEADLESS_SVC_DOMAIN:CLIENT_PORT,SCHEME://SVC_DOMAIN:SVC_CLIENT_PORT
    #
    # Assuming this, we can extract the HEADLESS_SVC_DOMAIN and obtain
    # every available endpoint
    read -r -a advertised_array <<<"$(tr ',;' ' ' <<<"$ETCD_ADVERTISE_CLIENT_URLS")"
    host="$(parse_uri "${advertised_array[0]}" "host")"
    port="$(parse_uri "${advertised_array[0]}" "port")"
    domain="${host#"${ETCD_NAME}."}"
    # When ETCD_CLUSTER_DOMAIN is set, we use that value instead of extracting
    # it from ETCD_ADVERTISE_CLIENT_URLS
    ! is_empty_value "$ETCD_CLUSTER_DOMAIN" && domain="$ETCD_CLUSTER_DOMAIN"
    # Depending on the K8s distro & the DNS plugin, it might need
    # a few seconds to associate the POD(s) IP(s) to the headless svc domain
    if retry_while "hostname_has_ips $domain"; then
        local -r ahosts="$(getent ahosts "$domain" | awk '{print $1}' | uniq | wc -l)"
        for i in $(seq 0 $((ahosts - 1))); do
            # We use the StatefulSet name stored in MY_STS_NAME to get the peer names based on the number of IPs registered in the headless service
            pod_name="${MY_STS_NAME}-${i}"
            if ! { [[ $only_others = true ]] && [[ "$pod_name" = "$MY_POD_NAME" ]]; }; then
                endpoints+=("${pod_name}.${ETCD_CLUSTER_DOMAIN}:${port:-2380}")
            fi
        done
    fi
    echo "${endpoints[*]}" | tr ' ' ','
}

########################
# Obtain etcdctl authentication flags to use
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   Array with extra flags to use for authentication
#########################
etcdctl_auth_flags() {
    local -a authFlags=()

    ! is_empty_value "$ETCD_ROOT_PASSWORD" && authFlags+=("--user" "root:$ETCD_ROOT_PASSWORD")
    echo "${authFlags[*]} $(etcdctl_auth_norbac_flags)"
}

########################
# Obtain etcdctl authentication flags to use (before RBAC is enabled)
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   Array with extra flags to use for authentication
#########################
etcdctl_auth_norbac_flags() {
    local -a authFlags=()

    if [[ $ETCD_AUTO_TLS = true ]]; then
        authFlags+=("--cert" "${ETCD_DATA_DIR}/fixtures/client/cert.pem" "--key" "${ETCD_DATA_DIR}/fixtures/client/key.pem")
    else
        [[ -f "$ETCD_CERT_FILE" ]] && [[ -f "$ETCD_KEY_FILE" ]] && authFlags+=("--cert" "$ETCD_CERT_FILE" "--key" "$ETCD_KEY_FILE")
        [[ -f "$ETCD_TRUSTED_CA_FILE" ]] && authFlags+=("--cacert" "$ETCD_TRUSTED_CA_FILE")
    fi
    if [[ -n "$ETCD_EXTRA_AUTH_FLAGS" ]]; then
        read -r -a extraAuthFlags <<< "$(tr ',;' ' ' <<< "$ETCD_EXTRA_AUTH_FLAGS")"
        authFlags+=("${extraAuthFlags[@]}")
    fi

    echo "${authFlags[*]}"
}

########################
# Configure etcd RBAC (do not confuse with K8s RBAC)
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   None
########################
etcd_configure_rbac() {

    ! is_etcd_running && etcd_start_bg
    read -r -a extra_flags <<<"$(etcdctl_auth_norbac_flags)"

    is_boolean_yes "$ETCD_ON_K8S" && extra_flags+=("--endpoints=$(etcdctl_get_endpoints)")
    if retry_while "etcdctl ${extra_flags[*]} member list" >/dev/null 2>&1; then
        if retry_while "etcdctl ${extra_flags[*]} auth status" >/dev/null 2>&1; then
            if etcdctl "${extra_flags[@]}" auth status | grep -q "Authentication Status: true"; then
                info "Authentication already enabled"
            else
                info "Enabling etcd authentication"
                etcdctl "${extra_flags[@]}" user add root --interactive=false <<<"$ETCD_ROOT_PASSWORD"
                etcdctl "${extra_flags[@]}" user grant-role root root
                etcdctl "${extra_flags[@]}" auth enable
            fi
        fi
    fi
    etcd_stop
}

########################
# Checks if etcd needs to bootstrap a new cluster
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   Boolean
########################
is_new_etcd_cluster() {
    local -a extra_flags
    read -r -a extra_flags <<<"$(etcdctl_auth_flags)"
    is_boolean_yes "$ETCD_ON_K8S" && extra_flags+=("--endpoints=$(etcdctl_get_endpoints)")
    ! debug_execute etcdctl endpoint status --cluster "${extra_flags[@]}"
}

########################
# Setup ETCD_ACTIVE_ENDPOINTS environment variable, will return the number of active endpoints , cluster size (including not active member) and the ETCD_ACTIVE_ENDPOINTS (which is also export)
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   List of Numbers (active_endpoints, cluster_size, ETCD_ACTIVE_ENDPOINTS)
########################
setup_etcd_active_endpoints() {
    local active_endpoints=0
    local -a extra_flags active_endpoints_array
    local -a endpoints_array=()
    local host port

    is_boolean_yes "$ETCD_ON_K8S" && read -r -a endpoints_array <<<"$(tr ',;' ' ' <<<"$(etcdctl_get_endpoints)")"
    local -r cluster_size=${#endpoints_array[@]}
    read -r -a advertised_array <<<"$(tr ',;' ' ' <<<"$ETCD_ADVERTISE_CLIENT_URLS")"
    host="$(parse_uri "${advertised_array[0]}" "host")"
    port="$(parse_uri "${advertised_array[0]}" "port")"
    if [[ $cluster_size -gt 0 ]]; then
        for e in "${endpoints_array[@]}"; do
            read -r -a extra_flags <<<"$(etcdctl_auth_flags)"
            extra_flags+=("--endpoints=$e")
            if [[ "$e" != "$host:$port" ]] && etcdctl endpoint health "${extra_flags[@]}" >/dev/null 2>&1; then
                debug "$e endpoint is active"
                ((active_endpoints++))
                active_endpoints_array+=("$e")
            fi
        done
        ETCD_ACTIVE_ENDPOINTS=$(echo "${active_endpoints_array[*]}" | tr ' ' ',')
        export ETCD_ACTIVE_ENDPOINTS
    fi
    echo "${active_endpoints} ${cluster_size} ${ETCD_ACTIVE_ENDPOINTS}"
}

########################
# Checks if there are enough active members, will also set ETCD_ACTIVE_ENDPOINTS
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   Boolean
########################
is_healthy_etcd_cluster() {
    local return_value=0
    local active_endpoints cluster_size
    read -r active_endpoints cluster_size ETCD_ACTIVE_ENDPOINTS <<<"$(setup_etcd_active_endpoints)"
    export ETCD_ACTIVE_ENDPOINTS

    if is_boolean_yes "$ETCD_DISASTER_RECOVERY"; then
        if [[ -f "/snapshots/.disaster_recovery" ]]; then
            # Remove current node from the ones that need to recover
            remove_in_file "/snapshots/.disaster_recovery" "$host:$port"
            # Remove nodes that do not exist anymore from the ones that need to recover
            read -r -a recovery_array <<<"$(tr '\n' ' ' <"/snapshots/.disaster_recovery")"
            for r in "${recovery_array[@]}"; do
                if [[ ! "${endpoints_array[*]}" =~ $r ]]; then
                    remove_in_file "/snapshots/.disaster_recovery" "$r"
                fi
            done
            if [[ $(wc -w <"/snapshots/.disaster_recovery") -eq 0 ]]; then
                debug "Last member to recover from the disaster!"
                rm "/snapshots/.disaster_recovery"
            fi
            return_value=1
        else
            if [[ $active_endpoints -lt $(((cluster_size + 1) / 2)) ]]; then
                debug "There are no enough active endpoints!"
                for e in "${endpoints_array[@]}"; do
                    [[ "$e" != "$host:$port" ]] && [[ "$e" != ":$port" ]] && echo "$e" >>"/snapshots/.disaster_recovery"
                done
                return_value=1
            fi
        fi
    else
        if [[ $active_endpoints -lt $(((cluster_size + 1) / 2)) ]]; then
            debug "There are no enough active endpoints!"
            return_value=1
        fi
    fi

    return $return_value
}

########################
# Recalculate initial cluster
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   String
########################
recalculate_initial_cluster() {
    local -a endpoints_array initial_members
    local domain host member_host member_port member_id port scheme

    if is_boolean_yes "$ETCD_ON_K8S"; then
        read -r -a endpoints_array <<<"$(tr ',;' ' ' <<<"$(etcdctl_get_endpoints)")"
        # This piece of code assumes this container is used on a K8s environment
        # where etcd members are part of a statefulset that uses a headless service
        # to create a unique FQDN per member. Under these circumstances, the
        # ETCD_INITIAL_ADVERTISE_PEER_URLS are created as follows:
        #   SCHEME://POD_NAME.HEADLESS_SVC_DOMAIN:PEER_PORT
        #
        # Assuming this, we can extract the HEADLESS_SVC_DOMAIN
        host="$(parse_uri "$ETCD_INITIAL_ADVERTISE_PEER_URLS" "host")"
        scheme="$(parse_uri "$ETCD_INITIAL_ADVERTISE_PEER_URLS" "scheme")"
        port="$(parse_uri "$ETCD_INITIAL_ADVERTISE_PEER_URLS" "port")"
        domain="${host#"${ETCD_NAME}."}"
        # When ETCD_CLUSTER_DOMAIN is set, we use that value instead of extracting
        # it from ETCD_INITIAL_ADVERTISE_PEER_URLS
        ! is_empty_value "$ETCD_CLUSTER_DOMAIN" && domain="$ETCD_CLUSTER_DOMAIN"
        for e in "${endpoints_array[@]}"; do
            member_host="$(parse_uri "$scheme://$e" "host")"
            member_port="$(parse_uri "$scheme://$e" "port")"
            member_id=${e%".$domain:$member_port"}
            initial_members+=("${member_id}=${scheme}://${member_host}:$port")
        done
        echo "${initial_members[*]}" | tr ' ' ','
    else
        # Nothing to do
        echo "$ETCD_INITIAL_CLUSTER"
    fi
}

########################
# Remove the old member from the cluster if it exists
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   None
#########################
remove_old_member_if_exist() {
    local old_member_id
    old_member_id=$(get_member_id)
    if ! is_empty_value "$old_member_id"; then
        info "Removing old member $old_member_id"
        local -a extra_flags
        read -r -a extra_flags <<<"$(etcdctl_auth_flags)"
        is_boolean_yes "$ETCD_ON_K8S" && extra_flags+=("--endpoints=$(etcdctl_get_endpoints)")
        etcdctl member remove "$old_member_id" "${extra_flags[@]}"
    fi
}

########################
# Add this member as a new member to the cluster
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   None
#########################
add_new_member() {
    info "Adding new member to existing cluster"
    local -a extra_flags
    read -r -a extra_flags <<<"$(etcdctl_auth_flags)"
    is_boolean_yes "$ETCD_ON_K8S" && extra_flags+=("--endpoints=$(etcdctl_get_endpoints)")
    extra_flags+=("--peer-urls=$ETCD_INITIAL_ADVERTISE_PEER_URLS")
    mkdir -p "$(dirname $ETCD_NEW_MEMBERS_ENV_FILE)" || true
    etcdctl member add "$ETCD_NAME" "${extra_flags[@]}" | grep "^ETCD_" >"$ETCD_NEW_MEMBERS_ENV_FILE"
    replace_in_file "$ETCD_NEW_MEMBERS_ENV_FILE" "^" "export "
    sync -d "$ETCD_NEW_MEMBERS_ENV_FILE"
}

########################
# Check that this node is still a member of the cluster
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   None
#########################
is_node_still_a_member() {
    local tmp_file
    local start_command=("etcd")

    tmp_file="$(mktemp)"
    # shellcheck disable=SC2064
    trap "rm -f ${tmp_file}" RETURN

    am_i_root && start_command=("run_as_user" "$ETCD_DAEMON_USER" "${start_command[@]}")
    [[ -f "$ETCD_CONF_FILE" ]] && start_command+=("--config-file" "$ETCD_CONF_FILE")
    "${start_command[@]}" > "$tmp_file" 2>&1 &
    
    while read -r line; do
        debug_execute echo "$line"
        if [[ "$line" =~ (established TCP streaming connection with remote peer|the member has been permanently removed from the cluster|ignored streaming request; ID mismatch|\"error\":\"cluster ID mismatch\") ]]; then
            etcd_stop
            break
        fi
    done < <(tail -f "$tmp_file")

    if grep -q "the member has been permanently removed from the cluster\|ignored streaming request; ID mismatch" "$tmp_file"; then
        info "The remote member ID is different from the local member ID"
        return 1
    elif grep -q "\"error\":\"cluster ID mismatch\"" "$tmp_file"; then
        info "The remote cluster ID is different from the local cluster ID"
        return 1
    fi

    info "The member is still part of the cluster"
    return 0
}

########################
# Ensure etcd is initialized
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   None
#########################
etcd_initialize() {
    local -a extra_flags initial_members
    local domain

    info "Initializing etcd"

    # Generate user configuration if ETCD_CFG_* variables are provided
    etcd_setup_from_environment_variables

    export ETCD_INITIAL_CLUSTER
    [[ -f "$ETCD_CONF_FILE" ]] && etcd_conf_write "initial-cluster" "$ETCD_INITIAL_CLUSTER"

    read -r -a initial_members <<<"$(tr ',;' ' ' <<<"$ETCD_INITIAL_CLUSTER")"
    if is_mounted_dir_empty "$ETCD_DATA_DIR"; then
        info "There is no data from previous deployments"
        if [[ ${#initial_members[@]} -gt 1 ]]; then
            if is_new_etcd_cluster; then
                info "Bootstrapping a new cluster"
                if is_boolean_yes "$ETCD_ON_K8S"; then
                    debug "Waiting for the headless svc domain to have an IP per initial member in the cluster"
                    if is_empty_value "$ETCD_CLUSTER_DOMAIN"; then
                        # This piece of code assumes this container is used on a K8s environment
                        # where etcd members are part of a statefulset that uses a headless service
                        # to create a unique FQDN per member. Under these circumstances, the
                        # ETCD_INITIAL_ADVERTISE_PEER_URLS are created as follows:
                        #   SCHEME://POD_NAME.HEADLESS_SVC_DOMAIN:PEER_PORT
                        #
                        # Assuming this, we can extract the HEADLESS_SVC_DOMAIN
                        host="$(parse_uri "$ETCD_INITIAL_ADVERTISE_PEER_URLS" "host")"
                        domain="${host#"${ETCD_NAME}."}"
                    else
                        # When ETCD_CLUSTER_DOMAIN is set, we use that value instead of extracting
                        # it from ETCD_INITIAL_ADVERTISE_PEER_URLS
                        domain="$ETCD_CLUSTER_DOMAIN"
                    fi
                    hostname_has_N_ips() {
                        local -r hostname="${1:?hostname is required}"
                        local -r n=${2:?number of ips is required}
                        local -r ready_hosts=$(getent ahosts "$hostname" | awk '{print $1}' | uniq | wc -l)
                        [[ $((ready_hosts % n)) -eq 0 ]] && [[ $((ready_hosts / n)) -ge 1 ]] && return 0
                        return 1
                    }
                    if ! retry_while "hostname_has_N_ips $domain ${#initial_members[@]}"; then
                        error "Headless service domain does not have an IP per initial member in the cluster"
                        exit 1
                    fi
                fi
            else
                # if an old member with the same name is already registered, we want to remove it first
                remove_old_member_if_exist
                info "Adding new member to existing cluster"
                ensure_dir_exists "$ETCD_DATA_DIR"
                add_self_to_cluster
            fi
        fi
        if is_boolean_yes "$ETCD_START_FROM_SNAPSHOT"; then
            if [[ -f "${ETCD_INIT_SNAPSHOTS_DIR}/${ETCD_INIT_SNAPSHOT_FILENAME}" ]]; then
                info "Restoring snapshot before initializing etcd cluster"
                local -a restore_args=("--data-dir" "$ETCD_DATA_DIR")
                if [[ ${#initial_members[@]} -gt 1 ]]; then
                    #
                    # Only recalculate the initial cluster config if it hasn't
                    # been provided.
                    #
                    if is_empty_value "$ETCD_INITIAL_CLUSTER"; then
                      ETCD_INITIAL_CLUSTER="$(recalculate_initial_cluster)"
                      export ETCD_INITIAL_CLUSTER
                    fi

                    [[ -f "$ETCD_CONF_FILE" ]] && etcd_conf_write "initial-cluster" "$ETCD_INITIAL_CLUSTER"

                    restore_args+=(
                        "--name" "$ETCD_NAME"
                        "--initial-cluster" "$ETCD_INITIAL_CLUSTER"
                        "--initial-cluster-token" "$ETCD_INITIAL_CLUSTER_TOKEN"
                        "--initial-advertise-peer-urls" "$ETCD_INITIAL_ADVERTISE_PEER_URLS"
                    )
                fi
                debug_execute etcdctl snapshot restore "${ETCD_INIT_SNAPSHOTS_DIR}/${ETCD_INIT_SNAPSHOT_FILENAME}" "${restore_args[@]}"
            else
                error "There was no snapshot to restore!"
                exit 1
            fi
        fi
    else
        info "Detected data from previous deployments"
        if [[ $(stat -c "%a" "$ETCD_DATA_DIR") != *700 ]]; then
            debug "Setting data directory permissions to 700 in a recursive way (required in etcd >=3.4.10)"
            debug_execute chmod -R 700 "$ETCD_DATA_DIR" || true
        fi
        if [[ ${#initial_members[@]} -gt 1 ]]; then
            member_id="$(get_member_id)"
            if ! is_healthy_etcd_cluster; then
                warn "Cluster not responding!"
                if is_boolean_yes "$ETCD_DISASTER_RECOVERY"; then
                    latest_snapshot_file="$(find /snapshots/ -maxdepth 1 -type f -name 'db-*' | sort | tail -n 1)"
                    if [[ "${latest_snapshot_file}" != "" ]]; then
                        info "Restoring etcd cluster from snapshot"
                        rm -rf "$ETCD_DATA_DIR"
                        #
                        # Only recalculate the initial cluster config if it hasn't
                        # been provided.
                        #
                        if is_empty_value "$ETCD_INITIAL_CLUSTER"; then
                          ETCD_INITIAL_CLUSTER="$(recalculate_initial_cluster)"
                          export ETCD_INITIAL_CLUSTER
                        fi
                        [[ -f "$ETCD_CONF_FILE" ]] && etcd_conf_write "initial-cluster" "$ETCD_INITIAL_CLUSTER"
                        debug_execute etcdctl snapshot restore "${latest_snapshot_file}" \
                            --name "$ETCD_NAME" \
                            --data-dir "$ETCD_DATA_DIR" \
                            --initial-cluster "$ETCD_INITIAL_CLUSTER" \
                            --initial-cluster-token "$ETCD_INITIAL_CLUSTER_TOKEN" \
                            --initial-advertise-peer-urls "$ETCD_INITIAL_ADVERTISE_PEER_URLS"
                    else
                        error "There was no snapshot to restore!"
                        exit 1
                    fi
                else
                    warn "Disaster recovery is disabled, the cluster will try to recover on it's own"
                fi
            else
                info "Cluster is healthy"
                if ! is_node_still_a_member; then
                    rm -rf "$ETCD_DATA_DIR"
                    remove_old_member_if_exist
                    add_new_member
                fi
                export ETCD_INITIAL_CLUSTER_STATE=existing
                [[ -f "$ETCD_CONF_FILE" ]] && etcd_conf_write "initial-cluster-state" "$ETCD_INITIAL_CLUSTER_STATE"
            fi
        fi
    fi

    # For both existing and new deployments, configure RBAC if set
    if [[ ${#initial_members[@]} -gt 1 ]]; then
        # When there's more than one etcd replica, RBAC should be only enabled in one member
        if ! is_empty_value "$ETCD_ROOT_PASSWORD" && [[ "${initial_members[0]}" = *"$ETCD_INITIAL_ADVERTISE_PEER_URLS"* ]]; then
            etcd_configure_rbac
        else
            debug "Skipping RBAC configuration in member $ETCD_NAME"
        fi
    else
        ! is_empty_value "$ETCD_ROOT_PASSWORD" && etcd_configure_rbac
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add self to cluster if not
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   None
#########################
add_self_to_cluster() {
    local -a extra_flags
    read -r -a extra_flags <<<"$(etcdctl_auth_flags)"
    # is_healthy_etcd_cluster will also set ETCD_ACTIVE_ENDPOINTS
    while ! is_healthy_etcd_cluster; do
        warn "Cluster not healthy, not adding self to cluster for now, keeping trying..."
        sleep 10
    done

    # only send req to healthy nodes

    if is_empty_value "$(get_member_id)"; then
        extra_flags+=("--endpoints=${ETCD_ACTIVE_ENDPOINTS}" "--peer-urls=$ETCD_INITIAL_ADVERTISE_PEER_URLS")
        while ! etcdctl member add "$ETCD_NAME" "${extra_flags[@]}" | grep "^ETCD_" >"$ETCD_NEW_MEMBERS_ENV_FILE"; do
            warn "Failed to add self to cluster, keeping trying..."
            sleep 10
        done
        replace_in_file "$ETCD_NEW_MEMBERS_ENV_FILE" "^" "export "
        sync -d "$ETCD_NEW_MEMBERS_ENV_FILE"
    else
        info "Node already in cluster"
    fi
    info "Loading env vars of existing cluster"
    . "$ETCD_NEW_MEMBERS_ENV_FILE"
}

########################
# Get this node's member_id in cluster, if not in cluster return empty string
# Globals:
#   ETCD_*
# Arguments:
#   None
# Returns:
#   String
#########################
get_member_id() {
    local ret
    local -a extra_flags

    read -r -a extra_flags <<<"$(etcdctl_auth_flags)"
    is_boolean_yes "$ETCD_ON_K8S" && extra_flags+=("--endpoints=$(etcdctl_get_endpoints)")
    ret=$(etcdctl "${extra_flags[@]}" member list | grep -w "$ETCD_INITIAL_ADVERTISE_PEER_URLS" | awk -F "," '{ print $1 }')
    # if not return zero
    if is_empty_value "$ret"; then
        info "No member id found"
        echo ""
    else
        info "member id: $ret"
        echo "$ret"
    fi
}
