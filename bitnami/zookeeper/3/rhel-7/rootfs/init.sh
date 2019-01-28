#!/bin/bash

##
## @brief     Helper function to show an error when ZOO_ENABLE_AUTH is set to no
## param $1   Input name
##
anonymous_login_error() {
    error "The $1 environment variable does not configure authentication. Set the environment variable ALLOW_ANONYMOUS_LOGIN=yes to allow unauthenticated users to connect to ZooKeeper. This is recommended only for development."
  exit 1
}

##
## @brief     Helper function to show a warning when the ALLOW_ANONYMOUS_LOGIN flag is enabled
##
anonymous_login_enabled_warn() {
  warn "You set the environment variable ALLOW_ANONYMOUS_LOGIN=${ALLOW_ANONYMOUS_LOGIN}. For safety reasons, do not use this flag in a production environment."
}


# Validate passwords
if [[ "$ALLOW_ANONYMOUS_LOGIN" =~ ^(yes|Yes|YES)$ ]]; then
    anonymous_login_enabled_warn
elif [[ ! "$ZOO_ENABLE_AUTH" =~ ^(yes|Yes|YES)$ ]]; then
    anonymous_login_error ZOO_ENABLE_AUTH
fi
