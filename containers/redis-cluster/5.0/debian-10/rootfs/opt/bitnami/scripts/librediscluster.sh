#!/bin/bash
#
# Bitnami Redis Cluster library

# shellcheck disable=SC1091
# shellcheck disable=SC2178
# shellcheck disable=SC2128
# shellcheck disable=SC1090

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libredis.sh

# Functions

########################
# Load global variables used on Redis configuration.
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
redis_cluster_env() {
    cat <<"EOF"
export REDIS_BASEDIR="/opt/bitnami/redis"
export REDIS_EXTRAS_DIR="/opt/bitnami/extra/redis"
export REDIS_VOLUME="/bitnami/redis"
export REDIS_TEMPLATES_DIR="${REDIS_EXTRAS_DIR}/templates"
export REDIS_TMPDIR="${REDIS_BASEDIR}/tmp"
export REDIS_LOGDIR="${REDIS_BASEDIR}/logs"
export PATH="${REDIS_BASEDIR}/bin:$PATH"
export REDIS_DAEMON_USER="redis"
export REDIS_DAEMON_GROUP="redis"
export REDIS_DISABLE_COMMANDS="${REDIS_DISABLE_COMMANDS:-}"
export POD_NAME="${POD_NAME:-}"
export REDIS_PORT="${REDIS_PORT:-6379}"
export REDIS_CLUSTER_CREATOR="${REDIS_CLUSTER_CREATOR:-no}"
export REDIS_CLUSTER_REPLICAS="${REDIS_CLUSTER_REPLICAS:-1}"
export REDIS_NODES="${REDIS_NODES:-}"
export REDIS_PASSWORD="${REDIS_PASSWORD:-}"
export REDIS_CLUSTER_DYNAMIC_IPS="${REDIS_CLUSTER_DYNAMIC_IPS:-yes}"
export REDIS_CLUSTER_ANNOUNCE_IP="${REDIS_CLUSTER_ANNOUNCE_IP:-}"
export REDIS_DNS_RETRIES="${REDIS_DNS_RETRIES:-120}"
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export REDIS_AOF_ENABLED="${REDIS_AOF_ENABLED:-yes}"
EOF
    if [[ -f "${REDIS_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export REDIS_PASSWORD="$(< "${REDIS_PASSWORD_FILE}")"
EOF
    fi
}

########################
# Validate settings in REDIS_* env vars.
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_cluster_validate() {
    debug "Validating settings in REDIS_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    empty_password_enabled_warn() {
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    }
    empty_password_error() {
        print_validation_error "The $1 environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
    }

    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        empty_password_enabled_warn
    else
        if ! is_boolean_yes "$REDIS_CLUSTER_CREATOR"; then
            [[ -z "$REDIS_PASSWORD" ]] && empty_password_error REDIS_PASSWORD
        fi
    fi

    if ! is_boolean_yes "$REDIS_CLUSTER_DYNAMIC_IPS"; then
        if ! is_boolean_yes "$REDIS_CLUSTER_CREATOR"; then
            [[ -z "$REDIS_CLUSTER_ANNOUNCE_IP" ]] && print_validation_error "To provide external access you need to provide the REDIS_CLUSTER_ANNOUNCE_IP env var"
        fi
    fi

    [[ -z "$REDIS_NODES" ]] && print_validation_error "REDIS_NODES is required"

    if [[ -z "$REDIS_PORT" ]]; then
        print_validation_error "REDIS_PORT cannot be empty"
    fi

    if is_boolean_yes "$REDIS_CLUSTER_CREATOR"; then
        [[ -z "$REDIS_CLUSTER_REPLICAS" ]] && print_validation_error "To create the cluster you need to provide the number of replicas"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Redis specific configuration to override the default one
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_cluster_override_conf() {
    # Redis configuration to override
    redis_conf_set daemonize no
    redis_conf_set cluster-enabled yes
    redis_conf_set cluster-config-file "${REDIS_VOLUME}/data/nodes.conf"

    if ! (is_boolean_yes "$REDIS_CLUSTER_DYNAMIC_IPS" || is_boolean_yes "$REDIS_CLUSTER_CREATOR"); then
        redis_conf_set cluster-announce-ip "$REDIS_CLUSTER_ANNOUNCE_IP"
    fi
}

########################
# Ensure Redis is initialized
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_cluster_initialize() {
    redis_configure_default
    redis_cluster_override_conf
}

########################
# Creates the Redis cluster
# Globals:
#   REDIS_*
# Arguments:
#   - $@ Array with the hostnames
# Returns:
#   None
#########################
redis_cluster_create() {
  local nodes=("$@")
  local ips=()
  for node in "${nodes[@]}"; do
    while [[ $(redis-cli -h "$node" -p "$REDIS_PORT" ping) != 'PONG' ]]; do
      echo "Node $node not ready, waiting for all the nodes to be ready..."
      sleep 1
    done
    ips=($(dns_lookup "$node") "${ips[@]}")
  done

  redis-cli --cluster create "${ips[@]/%/:${REDIS_PORT}}" --cluster-replicas "$REDIS_CLUSTER_REPLICAS" --cluster-yes || true
  if redis_cluster_check "${ips[0]}"; then
    echo "Cluster correctly created"
  else
    echo "The cluster was already created, the nodes should have recovered it"
  fi
}

#########################
## Checks if the cluster state is correct.
## Params:
##  - $1: node where to check the cluster state
#########################
redis_cluster_check() {
  local -r check=$(redis-cli --cluster check "$1":"$REDIS_PORT")
  if [[ $check =~ "All 16384 slots covered" ]]; then
    true
  else
    false
  fi
}

#########################
## Recovers the cluster when using dynamic IPs by changing them in the nodes.conf
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_cluster_update_ips() {
  IFS=' ' read -ra nodes <<< "$REDIS_NODES"

  declare -A host_2_ip_array # Array to map hosts and IPs
  # Update the IPs when a number of nodes > quorum change their IPs
  if [[ ! -f  "${REDIS_VOLUME}/data/nodes.sh" ]]; then
      # It is the first initialization so store the nodes
      for node in "${nodes[@]}"; do
        ip=$(wait_for_dns_lookup "$node" "$REDIS_DNS_RETRIES" 5)
        host_2_ip_array["$node"]="$ip"
      done
      echo "Storing map with hostnames and IPs"
      declare -p host_2_ip_array > "${REDIS_VOLUME}/data/nodes.sh"
  else
      # The cluster was already started
      . "${REDIS_VOLUME}/data/nodes.sh"
      # Update the IPs in the nodes.conf
      for node in "${nodes[@]}"; do
          newIP=$(wait_for_dns_lookup "$node" "$REDIS_DNS_RETRIES" 5)
          # The node can be new if we are updating the cluster, so catch the unbound variable error
          if [[ ${host_2_ip_array[$node]+true} ]]; then
            echo "Changing old IP ${host_2_ip_array[$node]} by the new one ${newIP}"
            nodesFile=$(sed "s/${host_2_ip_array[$node]}/$newIP/g" "${REDIS_VOLUME}/data/nodes.conf")
            echo "$nodesFile" > "${REDIS_VOLUME}/data/nodes.conf"
          fi
          host_2_ip_array["$node"]="$newIP"
      done
      declare -p host_2_ip_array > "${REDIS_VOLUME}/data/nodes.sh"
  fi
}
