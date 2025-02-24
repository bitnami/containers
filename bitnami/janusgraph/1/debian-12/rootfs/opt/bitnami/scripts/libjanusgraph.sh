#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami JanusGraph library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

########################
# Validate settings in JANUSGRAPH_* env vars
# Globals:
#   JANUSGRAPH_*
# Arguments:
#   None
# Returns:
#   None
#########################
janusgraph_validate() {
    debug "Validating settings in JANUSGRAPH_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname ${1} could not be resolved, this could lead to connection issues"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    if ! validate_ip "${JANUSGRAPH_HOST}"; then
        if ! is_hostname_resolved "${JANUSGRAPH_HOST}"; then
            print_validation_error print_validation_error "The value for JANUSGRAPH_HOST ($JANUSGRAPH_HOST) should be an IPv4 or IPv6 address, or it must be a resolvable hostname"
        fi
    fi
    ! is_empty_value "$JANUSGRAPH_PORT_NUMBER" && check_valid_port "JANUSGRAPH_PORT_NUMBER"

    return "$error_code"
}

########################
# Configure Janusgraph properties file from environment variables
# Globals:
#   JANUSGRAPH_CFG_*
# Arguments:
#   None
# Returns:
#   None
#########################
janusgraph_properties_configure_from_environment_variables() {
    info "Setting Janusgraph yaml file using JANUSGRAPH_CFG_* env variables"
    # Ensure Janusgraph properties file exists
    touch "$JANUSGRAPH_PROPERTIES"
    # Map environment variables to config properties
    for var in "${!JANUSGRAPH_CFG_@}"; do
        # Double underscores (__) will be replaced with dashes (-), while single underscores (_) will be replaced with dots (.)
        key="$(echo "$var" | sed -e 's/^JANUSGRAPH_CFG_//g' -e 's/__/\-/g' | sed -e 's/^JANUSGRAPH_CFG_//g' -e 's/_/\./g' | tr '[:upper:]' '[:lower:]')"

        value="${!var}"
        janusgraph_properties_conf_set "$key" "$value"
    done

    [[ -n "$JANUSGRAPH_STORAGE_PASSWORD" ]] && janusgraph_properties_conf_set "storage.password" "$JANUSGRAPH_STORAGE_PASSWORD"

    true
}

########################
# Set a property into the JanusGraph properties file.
# Globals:
#   JANUSGRAPH_*
# Arguments:
#   $1 - Key
#   $2 - Value
# Returns:
#   None
#########################
janusgraph_properties_conf_set() {
    local key=$1
    local value=$2

    # escape periods for usage in regular expressions
    # shellcheck disable=SC2001
    # shellcheck disable=SC2155
    local escaped_key=$(echo "${key}" | sed -e "s/\./\\\./g")

    # either override an existing entry, or append a new one
    if grep -E "^${escaped_key}=.*" "${JANUSGRAPH_PROPERTIES}" > /dev/null; then
        replace_in_file "$JANUSGRAPH_PROPERTIES" "${escaped_key}=.*" "${key}=${value}"
    else
        printf '\n%s=%s' "$key" "$value" >>"${JANUSGRAPH_PROPERTIES}"
    fi
}

########################
# Set a new value or override existing one in JanusGraph server file.
# Globals:
#   JANUSGRAPH_*
# Arguments:
#   $1 - Key
#   $2 - Value
#   $3 - Type
# Returns:
#   None
#########################
janusgraph_yaml_conf_set() {
    local -r key="${1:?Missing key}"
    local -r value="${2:-}"
    local -r type="${3:-string}"
    local -r file="${4:-$JANUSGRAPH_GREMLIN_CONF_FILE}"
    local -r tempfile=$(mktemp)

    case "$type" in
    string)
        yq eval "(.${key}) |= \"${value}\"" "$file" >"$tempfile"
        ;;
    int)
        yq eval "(.${key}) |= ${value}" "$file" >"$tempfile"
        ;;
    bool)
        yq eval "(.${key}) |= (\"${value}\" | test(\"true\"))" "$file" >"$tempfile"
        ;;
    *)
        error "Type unknown: ${type}"
        return 1
        ;;
    esac
    cp "$tempfile" "$file"
}

########################
# Set a property into the JanusGraph properties file.
# Globals:
#   JANUSGRAPH_*
# Arguments:
#   $1 - Key
#   $2 - Value
# Returns:
#   None
#########################
janusgraph_yaml_conf_del(){
    local -r key="${1:?Missing key}"
    local -r file="${2:-$JANUSGRAPH_GREMLIN_CONF_FILE}"
    local -r tempfile=$(mktemp)

    yq eval "del(.${key})" "$file" >"$tempfile"
    cp "$tempfile" "$file"
}

########################
# Configures Gremlin remote hosts
# Globals:
#   JANUSGRAPH_*
# Arguments:
#   $1 - Key
#   $2 - Value
# Returns:
#   None
#########################
janusgraph_configure_remote_hosts() {
    local -r file="${1:?Missing file}"
    local -r tempfile=$(mktemp)
    read -r -a remote_hosts <<<"$(tr ',;' ' ' <<<"${GREMLIN_REMOTE_HOSTS:-}")"

    if [[ -n "${remote_hosts[*]:-}" ]]; then
        janusgraph_yaml_conf_del "hosts" "$file"
        for host in "${remote_hosts[@]}"; do
            yq eval "(.hosts) += [\"${host}\"]" "$file" >"$tempfile"
            cp "$tempfile" "$file"
        done
    fi
}

########################
# Waits for storage backend to be ready
# Globals:
#   JANUSGRAPH_*
# Arguments:
#   None
# Returns:
#   None
#########################
wait_for_storage() {
    local -r file="$(mktemp --suffix .groovy)"

    info "Waiting for Storage backend to be ready..."

    echo "graph = JanusGraphFactory.open('${JANUSGRAPH_PROPERTIES}')" > "$file"
    if ! retry_while "debug_execute ${JANUSGRAPH_BIN_DIR}/gremlin.sh -e $file"; then
        error "Storage backend is not ready yet."
        exit 1
    fi
    info "Storage is ready"
}

########################
# Initialize JanusGraph
# Globals:
#   JANUSGRAPH_*
# Arguments:
#   None
# Returns:
#   None
#########################
janusgraph_initialize() {
    info "Initializing JanusGraph"

    if ! is_dir_empty "$JANUSGRAPH_MOUNTED_CONF_DIR"; then
        cp -Lr "$JANUSGRAPH_MOUNTED_CONF_DIR"/* "$JANUSGRAPH_CONF_DIR"
    fi

    # Janusgraph properties
    # Ref. https://docs.janusgraph.org/configs/configuration-reference/
    janusgraph_properties_configure_from_environment_variables

    if [[ -f "$JANUSGRAPH_GREMLIN_CONF_FILE" ]]; then
        info "Injected '$JANUSGRAPH_GREMLIN_CONF_FILE' file found. Skipping configuration."
    else
        info "Creating Janusgraph server file."
        cp "${JANUSGRAPH_CONF_DIR}/gremlin-server/gremlin-server.yaml" "$JANUSGRAPH_GREMLIN_CONF_FILE"
        # Gremlin settings
        # Ref. https://tinkerpop.apache.org/docs/3.4.4/reference/
        janusgraph_yaml_conf_set "host" "$JANUSGRAPH_HOST"
        janusgraph_yaml_conf_set "port" "$JANUSGRAPH_PORT_NUMBER" "int"
        janusgraph_yaml_conf_set "graphs.graph" "$JANUSGRAPH_PROPERTIES"
        # If GREMLIN_AUTOCONFIGURE_POOL is set to true, Gremlin will autodetect pool size
        # Recommended when using container resources requests/limits
        if is_boolean_yes "$GREMLIN_AUTOCONFIGURE_POOL"; then
            janusgraph_yaml_conf_del "threadPoolWorker"
            janusgraph_yaml_conf_del "gremlinPool"
        else
            janusgraph_yaml_conf_set "threadPoolWorker" "$GREMLIN_THREAD_POOL_WORKER" "int"
            janusgraph_yaml_conf_set "gremlinPool" "$GREMLIN_POOL" "int"
        fi
        # Delete metrics default section and configure those enabled via env vars
        janusgraph_yaml_conf_del "metrics"
        is_boolean_yes "$JANUSGRAPH_JMX_METRICS_ENABLED" && janusgraph_yaml_conf_set "metrics.jmxReporter.enabled" "true" "bool"
    fi

    # Wait until configured storage is ready
    wait_for_storage

    # Avoid exit code of previous commands to affect the result of this function
    true
}
