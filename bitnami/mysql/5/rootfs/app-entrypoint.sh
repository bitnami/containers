#!/bin/bash -e
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page
check_for_updates &

##
## @brief     Helper function to show an error when a password is empty and exit
## param $1   Input name
##
empty_password_error() {
  error "The $1 environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
  exit 1
}

##
## @brief     Helper function to show a warning when the ALLOW_EMPTY_PASSWORD flag is enabled
##
empty_password_enabled_warn() {
  warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
}

##
## @brief     Helper function to check deprecated environment variables and warn about them
## param $1   Deprecated environment variable to check
## param $2   Suggested environment variable to use
##
check_for_deprecated_env() {
  if [[ -n "$$1" ]]; then
    warn "The environment variable $1 is deprecated and will be removed in a future. Please use $2 instead"
  fi
}

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/init.sh" ]]; then
  # Check env vars to deprecate
  check_for_deprecated_env "MYSQL_MASTER_USER" "MYSQL_MASTER_ROOT_USER"
  export MYSQL_MASTER_ROOT_USER=${MYSQL_MASTER_USER:-${MYSQL_MASTER_ROOT_USER}}
  check_for_deprecated_env "MYSQL_MASTER_PASSWORD" "MYSQL_MASTER_ROOT_PASSWORD"
  export MYSQL_MASTER_ROOT_PASSWORD=${MYSQL_MASTER_PASSWORD:-${MYSQL_MASTER_ROOT_PASSWORD}}

  # Validate passwords
  if [[ "$ALLOW_EMPTY_PASSWORD" =~ ^(yes|Yes|YES)$ ]]; then
    empty_password_enabled_warn
  else
    # Root user
    if [[ -z "$MYSQL_ROOT_PASSWORD" ]]; then
      empty_password_error MYSQL_ROOT_PASSWORD
    fi
    # Replication user
    if [[ -n "$MYSQL_REPLICATION_USER" && -z "$MYSQL_REPLICATION_PASSWORD" ]]; then
      empty_password_error MYSQL_REPLICATION_PASSWORD
    fi
    # Additional user creation
    if [[ -n "$MYSQL_USER" && -z "$MYSQL_PASSWORD" ]]; then
      empty_password_error MYSQL_PASSWORD
    fi
  fi

  nami_initialize mysql
  info "Starting mysql..."
fi

exec tini -- "$@"
