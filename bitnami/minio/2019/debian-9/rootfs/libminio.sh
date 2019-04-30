#!/bin/bash
#
# Bitnami MinIO library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Libraries
. /libservice.sh
. /libos.sh
. /libvalidations.sh
. /libminioclient.sh

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
export MINIO_DATADIR="/data"
export MINIO_CERTSDIR="/certs"
export MINIO_SKIP_CLIENT="${MINIO_SKIP_CLIENT:-no}"
export MINIO_DISTRIBUTED_MODE_ENABLED="${MINIO_DISTRIBUTED_MODE_ENABLED:-no}"
export MINIO_PORT_NUMBER="${MINIO_PORT_NUMBER:-9000}"
export MINIO_DAEMON_USER="minio"
export MINIO_DAEMON_GROUP="minio"
export PATH="${MINIO_BASEDIR}/bin:$PATH"
EOF
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
            status="$(minio_client_execute admin service status local --json | jq -r .service)"
            if [[ "$status" = "on" ]]; then
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
    local exec
    local args
    exec=$(command -v minio)
    args=("server" "--certs-dir" "${MINIO_CERTSDIR}")
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
    ! is_minio_running && return
    info "Stopping MinIO..."
    minio_client_execute admin service stop local
    local counter=5
    while is_minio_running ; do
        if [[ "$counter" -ne 0 ]]; then
            break
        fi
        sleep 1;
        counter=$((counter - 1))
    done
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

    if is_boolean_yes "$MINIO_DISTRIBUTED_MODE_ENABLED"; then
        if [[ -z "${MINIO_ACCESS_KEY:-}" ]] || [[ -z "${MINIO_ACCESS_KEY:-}" ]]; then
            error "Distributed mode is enabled. Both MINIO_ACCESS_KEY and MINIO_ACCESS_KEY environment must be set"
            exit 1
        fi
        if [[ -z "${MINIO_DISTRIBUTED_NODES:-}" ]]; then
            error "Distributed mode is enabled. Nodes must be indicated setting the environment variable MINIO_DISTRIBUTED_NODES"
            exit 1
        else
            read -r -a nodes <<< "$(tr ',;' ' ' <<< "${MINIO_DISTRIBUTED_NODES}")"
            if [[ "${#nodes[@]}" -lt 4 ]] || (( "${#nodes[@]}" % 2 )); then
                error "Number of nodes must even and greater than 4."
                exit 1
            fi
        fi
    else
        if [[ -n "${MINIO_DISTRIBUTED_NODES:-}" ]]; then
            warn "Distributed mode is not enabled. The nodes set at the environment variable MINIO_DISTRIBUTED_NODES will be ignored."
        fi
    fi

    local validate_port_args=()
    ! am_i_root && validate_port_args+=("-unprivileged")
    if ! err=$(validate_port "${validate_port_args[@]}" "$MINIO_PORT_NUMBER"); then
        error "An invalid port was specified in the environment variable MINIO_PORT_NUMBER: $err"
        exit 1
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
            error "The HTTP log file specified at the environment variable MINIO_HTTP_TRACE is not writtable by current user \"$(id -u)\""
            exit 1
        fi
    fi
}
