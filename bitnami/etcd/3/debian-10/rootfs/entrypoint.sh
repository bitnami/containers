#!/bin/bash

##
## @brief     Helper function to show an error when ETCD_ROOT_PASSWORD does not enable the authentication
## param $1   Input name
##
authentication_enabled_error() {
    echo "The $1 environment variable does not enable authentication. Set the environment variable ALLOW_NONE_AUTHENTICATION=yes to allow the container to be started without authentication. This is recommended only for development."
    exit 1
}

##
## @brief     Helper function to show a warning when the ALLOW_NONE_AUTHENTICATION flag is enabled
##
authentication_enabled_warn() {
    echo "You set the environment variable ALLOW_NONE_AUTHENTICATION=${ALLOW_NONE_AUTHENTICATION}. For safety reasons, do not use this flag in a production environment."
}


# Validate authentication
if [[ "$ALLOW_NONE_AUTHENTICATION" =~ ^(yes|Yes|YES)$ ]]; then
    authentication_enabled_warn
elif [[ -z "$ETCD_ROOT_PASSWORD" ]]; then
    authentication_enabled_error ETCD_ROOT_PASSWORD
fi

# Validate authentication
if [[ ! -z "$ETCD_ROOT_PASSWORD" ]]; then
    echo "==> Enabling etcd authentication..."
    etcd > /dev/null 2>&1 &
    ETCD_PID=$!
    sleep 3
    echo "$ETCD_ROOT_PASSWORD" | etcdctl user add root --interactive=false
    etcdctl auth enable
    kill $ETCD_PID
fi


exec "$@"
