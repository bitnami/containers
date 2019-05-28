#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libnginx.sh
. /libfs.sh

# Auxiliar Functions

########################
# Ensure non-root user has write permissions on a set of directories
# Globals:
#   NGINX_*
# Arguments:
#   None
# Returns:
#   None
#########################
nginx_configure_permissions() {
    for dir in "/bitnami" "$NGINX_VOLUME" "${NGINX_CONFDIR}/server_blocks" "${NGINX_CONFDIR}/bitnami" "$NGINX_BASEDIR" "$NGINX_LOGDIR" "$NGINX_TMPDIR"; do
      ensure_dir_exists "$dir"
    done
    chmod -R g+rwX "$NGINX_VOLUME" "$NGINX_CONFDIR" "$NGINX_TMPDIR" "$NGINX_LOGDIR"
}

########################
# Unset HTTP_PROXY header to protect vs HTTPPOXY vulnerability
# Ref: https://www.digitalocean.com/community/tutorials/how-to-protect-your-server-against-the-httpoxy-vulnerability
# Globals:
#   NGINX_*
# Arguments:
#   None
# Returns:
#   None
#########################
nginx_patch_httpoxy_vulnerability() {
    debug "Unsetting HTTP_PROXY header..."
    echo '# Unset the HTTP_PROXY header' >> "${NGINX_CONFDIR}/fastcgi_params"
    echo 'fastcgi_param  HTTP_PROXY         "";' >> "${NGINX_CONFDIR}/fastcgi_params"
}

########################
# Prepare directories for users to mount its static files and certificates
# Globals:
#   NGINX_*
# Arguments:
#   None
# Returns:
#   None
#########################
nginx_prepare_directories() {
    # Users can mount their html sites at /app
    mv "${NGINX_BASEDIR}/html" /app
    ln -sf /app "${NGINX_BASEDIR}/html"
    # Users can mount their certificates at /certs
    ln -sf /certs "${NGINX_CONFDIR}/bitnami/certs"
    # Fix to avoid issues for those using the old structure (vhosts)
    warn "Creating a symlink to support mounting custom server_blocks at \"${NGINX_CONFDIR}/vhosts\". It will be deprecated in future versions."
    ln -sf "${NGINX_CONFDIR}/server_blocks" "${NGINX_CONFDIR}/vhosts"
    # Redirect all logging to stdout/stderr
    ln -sf /dev/stdout "$NGINX_LOGDIR/access.log"
    ln -sf /dev/stderr "$NGINX_LOGDIR/error.log"
}

# Load NGINX environment variables
eval "$(nginx_env)"

# Ensure non-root user has write permissions on a set of directories
nginx_configure_permissions
# Configure default HTTP port
nginx_config_http_port
# Unset HTTP_PROXY header to protect vs HTTPPOXY vulnerability
nginx_patch_httpoxy_vulnerability
# Prepare directories for users to mount its static files and certificates
nginx_prepare_directories
