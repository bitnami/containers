#!/bin/bash -e

. /libfile.sh
. /liblog.sh
. /libos.sh
. /libservice.sh
. /libvalidations.sh

# Echo env vars for nginx global configuration.
nginx_env() {
    cat <<"EOF"
export NGINX_EXTRAS_DIR=/opt/bitnami/extra/nginx
export NGINX_TEMPLATES_DIR=/opt/bitnami/extra/nginx/templates
export NGINX_BASEDIR=/opt/bitnami/nginx
export NGINX_VOLUME=/bitnami/nginx
export NGINX_TMPDIR=$NGINX_BASEDIR/tmp
export NGINX_CONFDIR=$NGINX_BASEDIR/conf
export NGINX_LOGDIR=$NGINX_BASEDIR/logs
export PATH=$NGINX_BASEDIR/sbin:$PATH
EOF
}

# Validate settings in NGINX_* env vars.
nginx_validate() {
    local validate_args=""
    if ! am_i_root; then
        validate_args="-unprivileged"
    fi
    if ! err=$(validate_port $validate_args "$NGINX_HTTP_PORT_NUMBER"); then
        error "The $var environment variable is invalid: $err"
        exit 1
    fi

    for var in NGINX_DAEMON_GROUP NGINX_DAEMON_USER; do
        local value=${!var}
        if am_i_root; then
            if [ -z "$value" ]; then
                error "The $var environment variable cannot be empty when running as root"
                exit 1
            fi
        else
            if [ -n "$value" ]; then
                error "The $var environment variable must be empty when running as non-root"
                exit 1
            fi
        fi
    done

}

# Ensure the mariadb volume is initialised.
nginx_initialize() {
    if [ -e "$NGINX_CONFDIR/nginx.conf" ]; then
        return
    fi
    info "nginx.conf not found. Applying bitnami configuration..."
    for dir in "$NGINX_TMPDIR" "$NGINX_CONFDIR" "$NGINX_CONFDIR/vhosts"; do
        ensure_dir_exists "$dir" "$NGINX_DAEMON_USER"
    done

    render-template "$NGINX_TEMPLATES_DIR/nginx.conf.tpl" > "$NGINX_CONFDIR/nginx.conf"
    echo 'fastcgi_param HTTP_PROXY "";' >> "$NGINX_CONFDIR/fastcgi_params"
}

# Checks if nginx is running
is_nginx_running() {
    local pid
    pid=$(get_pid "$NGINX_TMPDIR/nginx.pid")

    if [ -z "$pid" ]; then
        false
    else
        is_service_running "$pid"
    fi
}

# Stops nginx
nginx_stop() {
    stop_service_using_pid "$NGINX_TMPDIR/nginx.pid"
}

# Starts nginx
nginx_start() {
    if is_nginx_running ; then
        return
    fi
    "$NGINX_BASEDIR/sbin/nginx" -c "$NGINX_CONFDIR/nginx.conf"
}
