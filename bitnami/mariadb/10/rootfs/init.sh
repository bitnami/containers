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
  if [[ -n "${!1}" ]]; then
    warn "The environment variable $1 is deprecated and will be removed in a future. Please use $2 instead"
  fi
}

# Check env vars to deprecate
check_for_deprecated_env "MARIADB_MASTER_USER" "MARIADB_MASTER_ROOT_USER"
export MARIADB_MASTER_ROOT_USER=${MARIADB_MASTER_USER:-${MARIADB_MASTER_ROOT_USER}}
check_for_deprecated_env "MARIADB_MASTER_PASSWORD" "MARIADB_MASTER_ROOT_PASSWORD"
export MARIADB_MASTER_ROOT_PASSWORD=${MARIADB_MASTER_PASSWORD:-${MARIADB_MASTER_ROOT_PASSWORD}}

# Validate passwords
if [[ "$ALLOW_EMPTY_PASSWORD" =~ ^(yes|Yes|YES)$ ]]; then
  empty_password_enabled_warn
else
  # Root user
  if [[ -z "$MARIADB_ROOT_PASSWORD" ]]; then
    empty_password_error MARIADB_ROOT_PASSWORD
  fi
  # Replication user
  if [[ -n "$MARIADB_REPLICATION_USER" && -z "$MARIADB_REPLICATION_PASSWORD" ]]; then
    empty_password_error MARIADB_REPLICATION_PASSWORD
  fi
  # Additional user creation
  if [[ -n "$MARIADB_USER" && -z "$MARIADB_PASSWORD" ]]; then
    empty_password_error MARIADB_PASSWORD
  fi
fi
