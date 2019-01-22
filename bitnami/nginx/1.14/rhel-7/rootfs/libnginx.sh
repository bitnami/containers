#!/bin/bash
#
# Bitnami NGINX library

# shellcheck disable=SC1091

# Load Generic Libraries
. /libfile.sh
. /liblog.sh
. /libos.sh
. /libservice.sh
. /libvalidations.sh

# Functions

########################
# Check if NGINX is running
# Globals:
#   NGINX_TMPDIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_nginx_running() {
    local pid
    pid=$(get_pid_from_file "${NGINX_TMPDIR}/nginx.pid")

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Stop NGINX
# Globals:
#   NGINX_TMPDIR
# Arguments:
#   None
# Returns:
#   None
#########################
nginx_stop() {
    ! is_nginx_running && return
    debug "Stopping NGINX..."
    stop_service_using_pid "${NGINX_TMPDIR}/nginx.pid"
}

########################
# Start NGINX and wait until it's ready
# Globals:
#   NGINX_*
# Arguments:
#   None
# Returns:
#   None
#########################
nginx_start() {
    is_nginx_running && return
    debug "Starting NGIX..."
    if am_i_root; then
        gosu "$NGINX_DAEMON_USER" "${NGINX_BASEDIR}/sbin/nginx" -c "${NGINX_CONFDIR}/nginx.conf"
    else
        "${NGINX_BASEDIR}/sbin/nginx" -c "${NGINX_CONFDIR}/nginx.conf"
    fi

    local counter=3
    while ! is_nginx_running ; do
        if [[ "$counter" -ne 0 ]]; then
            break
        fi
        sleep 1;
        counter=$((counter - 1))
    done
}

########################
# Load global variables used on NGINX configuration
# Globals:
#   NGINX_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
nginx_env() {
    cat <<"EOF"
export NGINX_BASEDIR="/opt/bitnami/nginx"
export NGINX_VOLUME="/bitnami/nginx"
export NGINX_EXTRAS_DIR="/opt/bitnami/extra/nginx"
export NGINX_TEMPLATES_DIR="${NGINX_EXTRAS_DIR}/templates"
export NGINX_TMPDIR="${NGINX_BASEDIR}/tmp"
export NGINX_CONFDIR="${NGINX_BASEDIR}/conf"
export NGINX_LOGDIR="${NGINX_BASEDIR}/logs"
export PATH="${NGINX_BASEDIR}/sbin:$PATH"
EOF
}

########################
# Validate settings in NGINX_* env vars
# Globals:
#   NGINX_*
# Arguments:
#   None
# Returns:
#   None
#########################
nginx_validate() {
    info "Validating settings in NGINX_* env vars..."

    local validate_port_args=()
    ! am_i_root && validate_port_args+=("-unprivileged")
    if ! err=$(validate_port "${validate_port_args[@]}" "$NGINX_HTTP_PORT_NUMBER"); then
        error "An invalid port was specified in the environment variable NGINX_HTTP_PORT_NUMBER: $err"
        exit 1
    fi

    for var in "NGINX_DAEMON_USER" "NGINX_DAEMON_GROUP"; do
        if am_i_root; then
            if [[ -z "${!var}" ]]; then
                error "The $var environment variable cannot be empty when running as root"
                exit 1
            fi
        else
            if [[ -n "${!var}" ]]; then
                warn "The $var environment variable will be ignored when running as non-root"
            fi
        fi
    done
}

########################
# Ensure NGINX is initialized
# Globals:
#   NGINX_*
# Arguments:
#   None
# Returns:
#   None
#########################
nginx_initialize() {
    info "Initializing NGINX..."

    # Persisted configuration files from old versions
    if [[ -f "$NGINX_VOLUME/conf/nginx.conf" ]]; then
        warn "'nginx.conf' was found in a legacy location: ${NGINX_VOLUME}/conf/nginx.conf"
        warn "  Please use ${NGINX_CONFDIR}/nginx.conf instead"
        debug "Moving 'nginx.conf' file to new location..."
        cp "$NGINX_VOLUME/conf/nginx.conf" "$NGINX_CONFDIR/nginx.conf"
    fi
    if ! is_dir_empty "$NGINX_VOLUME/conf/vhosts"; then
        warn "Custom vhosts config files were found in a legacy directory: $NGINX_VOLUME/conf/vhosts"
        warn "  Please use ${NGINX_CONFDIR}/vhosts instead"
        debug "Moving vhosts config files to new location..."
        cp -r "$NGINX_VOLUME/conf/vhosts" "$NGINX_CONFDIR"
    fi

    if [[ -e "${NGINX_CONFDIR}/nginx.conf" ]]; then
        debug "Custom configuration detected. Using it..."
        return
    else
        debug "'nginx.conf' not found. Applying bitnami configuration..."
        debug "Ensuring expected directories/files exist..."
        for dir in "$NGINX_TMPDIR" "$NGINX_CONFDIR" "${NGINX_CONFDIR}/vhosts"; do
            ensure_dir_exists "$dir" "$NGINX_DAEMON_USER"
        done
        debug "Rendering 'nginx.conf.tpl' template..."
        render-template "${NGINX_TEMPLATES_DIR}/nginx.conf.tpl" > "${NGINX_CONFDIR}/nginx.conf"
        echo 'fastcgi_param HTTP_PROXY "";' >> "${NGINX_CONFDIR}/fastcgi_params"
    fi
}
