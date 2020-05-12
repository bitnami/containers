#!/bin/bash
#
# Bitnami MinIO library

# shellcheck disable=SC1091

# Load Libraries
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libminioclient.sh

# Functions

########################
# Load global variables used on MinIO configuration
# Globals:
#   MINIO_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
minio_env() {
    cat <<"EOF"
export MINIO_BASEDIR="/opt/bitnami/minio"
export MINIO_LOGDIR="${MINIO_BASEDIR}/log"
export MINIO_SECRETSDIR="${MINIO_BASEDIR}/secrets"
export MINIO_DATADIR="/data"
export MINIO_CERTSDIR="/certs"
export MINIO_SKIP_CLIENT="${MINIO_SKIP_CLIENT:-no}"
export MINIO_DISTRIBUTED_MODE_ENABLED="${MINIO_DISTRIBUTED_MODE_ENABLED:-no}"
export MINIO_DEFAULT_BUCKETS="${MINIO_DEFAULT_BUCKETS:-}"
export MINIO_PORT_NUMBER="${MINIO_PORT_NUMBER:-9000}"
export MINIO_DAEMON_USER="minio"
export MINIO_DAEMON_GROUP="minio"
export PATH="${MINIO_BASEDIR}/bin:$PATH"
export MINIO_FORCE_NEW_KEYS="${MINIO_FORCE_NEW_KEYS:-no}"
EOF
    if [[ -n "${MINIO_ACCESS_KEY_FILE:-}" ]]; then
        cat <<"EOF"
export MINIO_ACCESS_KEY="$(< "${MINIO_ACCESS_KEY_FILE}")"
EOF
    else
        cat <<"EOF"
export MINIO_ACCESS_KEY="${MINIO_ACCESS_KEY:-minio}"
EOF
    fi
    if [[ -n "${MINIO_SECRET_KEY_FILE:-}" ]]; then
        cat <<"EOF"
export MINIO_SECRET_KEY="$(< "${MINIO_SECRET_KEY_FILE}")"
EOF
    else
        cat <<"EOF"
export MINIO_SECRET_KEY="${MINIO_SECRET_KEY:-miniosecret}"
EOF
    fi
}

########################
# Checks if MinIO is running
# Globals:
#   MINIO_PID
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_minio_running() {
    local status
    if [[ -z "${MINIO_PID:-}" ]]; then
        false
    else
        if ! is_service_running "$MINIO_PID"; then
            false
        else
            status="$(minio_client_execute_timeout admin info local --json | jq -r .info.mode)"
            if [[ "$status" = "online" ]]; then
                true
            else
                false
            fi
        fi
    fi
}

########################
# Start MinIO in background and wait until it's ready
# Globals:
#   MINIO_*
# Arguments:
#   None
# Returns:
#   None
#########################
minio_start_bg() {
    local -r exec=$(command -v minio)
    local args=("server" "--certs-dir" "${MINIO_CERTSDIR}")

    if is_boolean_yes "$MINIO_DISTRIBUTED_MODE_ENABLED"; then
        read -r -a nodes <<< "$(tr ',;' ' ' <<< "${MINIO_DISTRIBUTED_NODES}")"
        for node in "${nodes[@]}"; do
            args+=("http://${node}:${MINIO_PORT_NUMBER}/${MINIO_DATADIR}")
        done
    else
        args+=("--address" ":${MINIO_PORT_NUMBER}" "${MINIO_DATADIR}")
    fi

    is_minio_running && return
    info "Starting MinIO in background..."
    if [[ "${BITNAMI_DEBUG:-false}" = true ]]; then
        "${exec}" "${args[@]}" &
    else
        "${exec}" "${args[@]}" >/dev/null 2>&1 &
    fi
    export MINIO_PID="$!"
    sleep 10
}

########################
# Stop MinIO
# Arguments:
#   None
# Returns:
#   None
#########################
minio_stop() {
    if is_minio_running; then
        info "Stopping MinIO..."
        minio_client_execute_timeout admin service stop local >/dev/null 2>&1 || true

        local counter=5
        while is_minio_running; do
            if [[ "$counter" -ne 0 ]]; then
                break
            fi
            sleep 1;
            counter=$((counter - 1))
        done
    else
        info "MinIO is already stopped..."
    fi
}

########################
# Validate settings in MINIO_* env vars.
# Globals:
#   MINIO_*
# Arguments:
#   None
# Returns:
#   None
#########################
minio_validate() {
    debug "Validating settings in MINIO_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_yes_no_value() {
        if ! is_yes_no_value "${!1}"; then
            print_validation_error "The allowed values for $1 are [yes, no]"
        fi
    }
    check_allowed_port() {
        local validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        if ! err=$(validate_port "${validate_port_args[@]}" "${!1}"); then
            print_validation_error "An invalid port was specified in the environment variable $1: $err"
        fi
    }

    if is_boolean_yes "$MINIO_DISTRIBUTED_MODE_ENABLED"; then
        if [[ -z "${MINIO_ACCESS_KEY:-}" ]] || [[ -z "${MINIO_ACCESS_KEY:-}" ]]; then
            print_validation_error "Distributed mode is enabled. Both MINIO_ACCESS_KEY and MINIO_ACCESS_KEY environment must be set"
        fi
        if [[ -z "${MINIO_DISTRIBUTED_NODES:-}" ]]; then
            print_validation_error "Distributed mode is enabled. Nodes must be indicated setting the environment variable MINIO_DISTRIBUTED_NODES"
        else
            read -r -a nodes <<< "$(tr ',;' ' ' <<< "${MINIO_DISTRIBUTED_NODES}")"
            if [[ "${#nodes[@]}" -lt 4 ]] || (( "${#nodes[@]}" % 2 )); then
                print_validation_error "Number of nodes must even and greater than 4."
            fi
        fi
    else
        if [[ -n "${MINIO_DISTRIBUTED_NODES:-}" ]]; then
            warn "Distributed mode is not enabled. The nodes set at the environment variable MINIO_DISTRIBUTED_NODES will be ignored."
        fi
    fi
    if [[ -n "${MINIO_BROWSER:-}" ]]; then
        shopt -s nocasematch
        if [[ "$MINIO_BROWSER" = "off" ]]; then
            warn "Access to MinIO web UI is disabled!! More information at: https://github.com/minio/minio/tree/master/docs/config/#browser"
        fi
        shopt -u nocasematch
    fi
    if [[ -n "${MINIO_HTTP_TRACE:-}" ]]; then
        if [[ -w "$MINIO_HTTP_TRACE" ]]; then
            info "HTTP log trace enabled. Find the HTTP logs at: $MINIO_HTTP_TRACE"
        else
            print_validation_error "The HTTP log file specified at the environment variable MINIO_HTTP_TRACE is not writtable by current user \"$(id -u)\""
        fi
    fi

    check_yes_no_value MINIO_SKIP_CLIENT
    check_yes_no_value MINIO_DISTRIBUTED_MODE_ENABLED
    check_yes_no_value MINIO_FORCE_NEW_KEYS
    check_allowed_port MINIO_PORT_NUMBER

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Create default buckets
# Globals:
#   MINIO_DEFAULT_BUCKETS
# Arguments:
#   None
# Returns:
#   None
#########################
minio_create_default_buckets() {
    if [[ -n "$MINIO_DEFAULT_BUCKETS" ]]; then
        read -r -a buckets <<< "$(tr ',;' ' ' <<< "${MINIO_DEFAULT_BUCKETS}")"
        info "Creating default buckets..."
        for b in "${buckets[@]}"; do
            if ! minio_client_bucket_exists "local/${b}"; then
                if [[ -n "${MINIO_REGION_NAME:-}" ]]; then
                    minio_client_execute mb "--region" "${MINIO_REGION_NAME}" "local/${b}"
                else
                    minio_client_execute mb "local/${b}"
                fi
            else
                info "Bucket local/${b} already exists, skipping creation."
            fi
        done
    fi
}

########################
# Regenerate MinIO credentials
# Globals:
#   MINIO_*
# Arguments:
#   None
# Returns:
#   None
#########################
minio_regenerate_keys() {
    local error_code=0
    if is_boolean_yes "$MINIO_FORCE_NEW_KEYS" && [[ -f "${MINIO_DATADIR}/.access_key" ]] && [[ -f "${MINIO_DATADIR}/.secret_key" ]]; then
        MINIO_ACCESS_KEY_OLD="$(cat "${MINIO_DATADIR}/.access_key")"
        MINIO_SECRET_KEY_OLD="$(cat "${MINIO_DATADIR}/.secret_key")"
        if [[ "$MINIO_ACCESS_KEY_OLD" != "$MINIO_ACCESS_KEY" ]] || [[ "$MINIO_SECRET_KEY_OLD" != "$MINIO_SECRET_KEY" ]]; then
            info "Reconfiguring MinIO credentials..."
            export MINIO_ACCESS_KEY_OLD MINIO_SECRET_KEY_OLD
            # Restart MinIO to reconfigure credentials
            # ref: https://docs.min.io/docs/minio-server-configuration-guide.html
            minio_start_bg
            info "Forcing container restart after key regeneration"
            error_code=1
        fi
    fi
    echo "$MINIO_ACCESS_KEY" > "${MINIO_DATADIR}/.access_key"
    echo "$MINIO_SECRET_KEY" > "${MINIO_DATADIR}/.secret_key"
    chmod 600 "${MINIO_DATADIR}/.secret_key" "${MINIO_DATADIR}/.access_key"
    exit $error_code
}

########################
# Return the node name of this instance
# Globals:
#   MINIO_DISTRIBUTED_MODE_ENABLED
#   MINIO_DISTRIBUTED_NODES
# Arguments:
#   None
# Returns:
#   None
#########################
minio_node_hostname() {
    if is_boolean_yes "$MINIO_DISTRIBUTED_MODE_ENABLED"; then
        read -r -a nodes <<< "$(tr ',;' ' ' <<< "${MINIO_DISTRIBUTED_NODES}")"
        for node in "${nodes[@]}"; do
            [[ $(get_machine_ip) = $(dns_lookup "$node") ]] && echo "$node" && return
        done
        error "Could not find own node in MINIO_DISTRIBUTE_NODES: ${MINIO_DISTRIBUTED_NODES}"
        exit 1
    else
        echo "localhost"
    fi
}
