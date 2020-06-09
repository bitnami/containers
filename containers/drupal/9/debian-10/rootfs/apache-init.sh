#!/bin/bash

# Check whether Apache ports must be configured
if [[ -n "${APACHE_HTTP_PORT_NUMBER:-}" || -n "${APACHE_HTTPS_PORT_NUMBER:-}" ]]; then
    export APACHE_ENABLE_CUSTOM_PORTS="yes"
fi

# Copy vhosts file
if [[ "$(ls -A /vhosts 2>/dev/null)" ]]; then
    info "Found vhost definitions in /vhosts. Copying them to /opt/bitnami/apache/conf/vhosts"
    cp -r /vhosts/* /opt/bitnami/apache/conf/vhosts
fi

# Mount certificate files
if [[ -d "/opt/bitnami/apache/certs" ]]; then
    warn "The directory '/opt/bitnami/apache/certs' was externally mounted. This is a legacy configuration and will be deprecated soon. Please mount certificate files at '/opt/bitnami/apache/conf/bitnami/certs' instead. Find an example at: https://github.com/bitnami/bitnami-docker-apache#using-custom-ssl-certificates"
    warn "Restoring certificates at '/opt/bitnami/apache/certs' to '/opt/bitnami/apache/conf/bitnami/certs'..."
    rm -rf /opt/bitnami/apache/conf/bitnami/certs
    ln -sf /opt/bitnami/apache/certs /opt/bitnami/apache/conf/bitnami/certs
elif [ "$(ls -A /certs 2>/dev/null)" ]; then
    info "Mounting certificates files from /certs..."
    rm -rf /opt/bitnami/apache/conf/bitnami/certs
    ln -sf /certs /opt/bitnami/apache/conf/bitnami/certs
fi
