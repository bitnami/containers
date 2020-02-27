#!/bin/bash

# Check whether custom NGINX ports must be configured
if [[ -n "${NGINX_HTTP_PORT_NUMBER:-}" || -n "${NGINX_HTTPS_PORT_NUMBER:-}" ]]; then
    export NGINX_ENABLE_CUSTOM_PORTS="yes"
fi
