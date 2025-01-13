#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Neo4j library

# shellcheck disable=SC1091
# shellcheck disable=SC1090

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in NEO4J_* env. variables
# Globals:
#   NEO4J_*
# Arguments:
#   None
# Returns:
#   None
#########################
neo4j_validate() {
    info "Validating settings in NEO4J_* env vars..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "${1} must be set"
        fi
    }
    check_true_false_value() {
        if ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are: true false"
        fi
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

    check_empty_value "NEO4J_PASSWORD"
    check_true_false_value "NEO4J_ALLOW_UPGRADE"
    check_true_false_value "NEO4J_APOC_IMPORT_FILE_ENABLED"
    check_true_false_value "NEO4J_APOC_IMPORT_FILE_USE_NEO4J_CONFIG"
    check_valid_port "NEO4J_BOLT_PORT_NUMBER"
    check_valid_port "NEO4J_HTTP_PORT_NUMBER"
    check_valid_port "NEO4J_HTTPS_PORT_NUMBER"

    if ! validate_ipv4 "${NEO4J_BIND_ADDRESS}"; then
        if ! is_hostname_resolved "${NEO4J_BIND_ADDRESS}"; then
            print_validation_error "The value for NEO4J_BIND_ADDRESS ($NEO4J_BIND_ADDRESS) should be an IPv4 address or it must be a resolvable hostname"
        fi
    fi

    ! is_empty_value "$NEO4J_HOST" && check_resolved_hostname "$NEO4J_HOST"

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

#########################
# Stop NEO4J
# Globals:
#   NEO4J_*
# Arguments:
#   None
# Returns:
#   None
#########################
neo4j_stop() {
    info "Stopping neo4j"
    neo4j stop
}

########################
# Check if Neo4j is running
# Globals:
#   NEO4J_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether Neo4j is running
########################
is_neo4j_running() {
    neo4j status | grep -q "Neo4j is running at pid"
}

########################
# Check if Neo4j is running
# Globals:
#   NEO4J_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether Neo4j is not running
########################
is_neo4j_not_running() {
    ! is_neo4j_running
}

########################
# Update the memory settings based on the neo4j-admin memrec command
# Globals:
#   NEO4J_*
# Arguments:
#   None
# Returns:
#   None
#########################
neo4j_configure_memory_settings() {
    ## neo4j-admin memrec returns the settings to be added in neo4j.conf
    ## Source: https://neo4j.com/docs/operations-manual/current/tools/neo4j-admin-memrec/#neo4j-admin-memrec
    local -a neo4j_admin_args=("memrec")
    if [ "$(get_neo4j_major_version)" -ge 5 ]; then
        neo4j_admin_args=("server" "memory-recommendation")
    fi
    info "Adjusting memory settings"
    while IFS= read -r setting; do
        neo4j_conf_set "${setting%=*}" "${setting#*=}"
    done < <(neo4j-admin "${neo4j_admin_args[@]}" | grep -E "^[^#].*=")
}

########################
# Add or modify an entry in the Neo4j configuration file
# Globals:
#   NEO4J_*
# Arguments:
#   $1 - Variable name
#   $2 - Value to assign to the variable
# Returns:
#   None
#########################
neo4j_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    local -r file="${3:-${NEO4J_CONF_FILE}}"
    debug "Setting ${key} to '${value}' in Neo4j configuration file ${file}"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(#\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<<"$key")\s*=\s*(.*)"
    local entry="${key} = ${value}"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$file"; then
        # It exists, so replace the line
        if [[ "${key}" =~ jvm.additional ]]; then
            append_file_after_last_match "$file" "$sanitized_pattern" "$entry"
        else
            replace_in_file "$file" "$sanitized_pattern" "$entry"
        fi
    else
        echo "$entry" >>"$file"
    fi
}

########################
# Set the initial password of the native user 'neo4j'
# Globals:
#   NEO4J_*
# Arguments:
#   None
# Returns:
#   None
#########################
neo4j_create_admin_user() {
    ## Set initial password
    ## Source: https://neo4j.com/docs/operations-manual/current/configuration/set-initial-password/
    info "Configuring initial password"
    local -a neo4j_admin_args=("set-initial-password")
    if [ "$(get_neo4j_major_version)" -ge 5 ]; then
        neo4j_admin_args=("dbms" "set-initial-password")
    fi

    if am_i_root; then
        debug_execute run_as_user "$NEO4J_DAEMON_USER" neo4j-admin "${neo4j_admin_args[@]}" "$NEO4J_PASSWORD"
    else
        debug_execute neo4j-admin "${neo4j_admin_args[@]}" "$NEO4J_PASSWORD"
    fi
}

#########################
# Initialize NEO4J
# Globals:
#   NEO4J_*
# Arguments:
#   None
# Returns:
#   None
#########################
neo4j_initialize() {
    ## The get started guide only specifies how to untar the neo4j tarball.
    ## The logic in this function is based on the sections here https://neo4j.com/docs/operations-manual/current/configuration/
    info "Initializing Neo4j ..."

    find "${NEO4J_RUN_DIR}" -type f -name "neo4j*.pid" -delete
    find "${NEO4J_LOGS_DIR}" -type f -name "neo4j*.log" -delete

    if ! is_mounted_dir_empty "$NEO4J_MOUNTED_CONF_DIR"; then
        info "Copying mounted configuration"
        cp -Lr "${NEO4J_MOUNTED_CONF_DIR}/." "$NEO4J_CONF_DIR"
    fi

    if ! is_mounted_dir_empty "$NEO4J_MOUNTED_PLUGINS_DIR"; then
        info "Copying mounted plugins"
        cp -Lr "${NEO4J_MOUNTED_PLUGINS_DIR}/." "$NEO4J_PLUGINS_DIR"
    fi

    info "Configuring Neo4j with settings provided via environment variables"
    if ! [[ -f "${NEO4J_MOUNTED_CONF_DIR}/neo4j.conf" ]]; then
        configure_neo4j_connector_settings
    else
        info "Found mounted neo4j.conf file in ${NEO4J_MOUNTED_CONF_DIR}/neo4j.conf. The general Neo4j configuration will be skipped"
    fi

    if ! [[ -f "${NEO4J_MOUNTED_CONF_DIR}/apoc.conf" ]]; then
        ## Apoc plugin configuration
        ## Source: https://neo4j.com/labs/apoc/4.2/config/
        neo4j_conf_set "apoc.import.file.enabled" "$NEO4J_APOC_IMPORT_FILE_ENABLED" "$NEO4J_APOC_CONF_FILE"
        neo4j_conf_set "apoc.import.file.use_neo4j_config" "$NEO4J_APOC_IMPORT_FILE_USE_NEO4J_CONFIG" "$NEO4J_APOC_CONF_FILE"
    else
        info "Found mounted apoc.conf file in ${NEO4J_MOUNTED_CONF_DIR}/apoc.conf. The APOC plugin configuration will be skipped"
    fi

    if is_mounted_dir_empty "$NEO4J_DATA_DIR"; then
        info "Deploying Neo4j from scratch"
        neo4j_create_admin_user
    else
        info "Deploying Neo4j with persisted data"
    fi

    # When running as 'root' user, ensure the Neo4j user has ownership
    if am_i_root; then
        info "Configuring file permissions for Neo4j"
        for dir in "$NEO4J_LOGS_DIR" "$NEO4J_DATA_DIR" "$NEO4J_RUN_DIR" "$NEO4J_METRICS_DIR"; do
            configure_permissions_ownership "$dir" -u "$NEO4J_DAEMON_USER" -g "$NEO4J_DAEMON_GROUP" -d 755 -f 644
        done
    fi
}

########################
# Run custom initialization scripts
# Globals:
#   NEO4J_*
# Arguments:
#   None
# Returns:
#   None
#########################
neo4j_custom_init_scripts() {
    if [[ -n $(find "${NEO4J_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh") ]] && [[ ! -f "${NEO4J_INITSCRIPTS_DIR}/.user_scripts_initialized" ]]; then
        info "Loading user's custom files from ${NEO4J_INITSCRIPTS_DIR} ..."
        local -r tmp_file="/tmp/filelist"
        find "${NEO4J_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh" | sort >"$tmp_file"
        while read -r f; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    debug "Executing $f"
                    "$f"
                else
                    debug "Sourcing $f"
                    . "$f"
                fi
                ;;
            *) debug "Ignoring $f" ;;
            esac
        done <$tmp_file
        rm -f "$tmp_file"
        touch "$NEO4J_VOLUME_DIR"/.user_scripts_initialized
    fi
}

########################
# Returns neo4j major version
# Globals:
#   NEO4J_BASE_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
get_neo4j_major_version() {
    neo4j_version="$("${NEO4J_BASE_DIR}/bin/neo4j" version)"
    neo4j_version="${neo4j_version#"neo4j "}"
    major_version="$(get_sematic_version "$neo4j_version" 1)"
    echo "${major_version:-0}"
}

########################
# Configure connectors settings
# Globals:
#   NEO4J_*
# Arguments:
#   None
# Returns:
#   None
#########################
configure_neo4j_connector_settings() {
    local -r host="${NEO4J_HOST:-$(get_machine_ip)}"
    local -r neo4j_major_version="$(get_neo4j_major_version)"
    if [ "$neo4j_major_version" -eq 4 ]; then
        ## Connector configuration
        ## Source: https://neo4j.com/docs/operations-manual/current/configuration/connectors/
        # Listen address configuration settings
        neo4j_conf_set "dbms.default_listen_address" "$NEO4J_BIND_ADDRESS"
        neo4j_conf_set "dbms.connector.bolt.listen_address" ":${NEO4J_BOLT_PORT_NUMBER}"
        neo4j_conf_set "dbms.connector.http.listen_address" ":${NEO4J_HTTP_PORT_NUMBER}"
        neo4j_conf_set "dbms.connector.https.listen_address" ":${NEO4J_HTTPS_PORT_NUMBER}"
        # Advertised address configuration settings
        neo4j_conf_set "dbms.default_advertised_address" "$host"
        neo4j_conf_set "dbms.connector.bolt.advertised_address" ":${NEO4J_BOLT_ADVERTISED_PORT_NUMBER}"
        neo4j_conf_set "dbms.connector.http.advertised_address" ":${NEO4J_HTTP_ADVERTISED_PORT_NUMBER}"
        neo4j_conf_set "dbms.connector.https.advertised_address" ":${NEO4J_HTTPS_ADVERTISED_PORT_NUMBER}"
        # TLS settings
        neo4j_conf_set "dbms.connector.bolt.tls_level" "${NEO4J_BOLT_TLS_LEVEL}"
        [[ "$NEO4J_BOLT_TLS_LEVEL" == "REQUIRED" || "$NEO4J_BOLT_TLS_LEVEL" == "OPTIONAL" ]] && neo4j_conf_set "dbms.ssl.policy.bolt.enabled" "true"
        neo4j_conf_set "dbms.connector.https.enabled" "${NEO4J_HTTPS_ENABLED}"
        neo4j_conf_set "dbms.ssl.policy.https.enabled" "${NEO4J_HTTPS_ENABLED}"
        ## Upgrade configuration (This is for allowing automatic schema upgrades)
        ## Source: https://neo4j.com/docs/upgrade-migration-guide/current/upgrade/upgrade-4.3/deployment-upgrading/
        neo4j_conf_set "dbms.allow_upgrade" "$NEO4J_ALLOW_UPGRADE"
    elif [ "$neo4j_major_version" -ge 5 ]; then
        # Listen address configuration settings
        neo4j_conf_set "server.default_listen_address" "$NEO4J_BIND_ADDRESS"
        neo4j_conf_set "server.bolt.listen_address" ":${NEO4J_BOLT_PORT_NUMBER}"
        neo4j_conf_set "server.http.listen_address" ":${NEO4J_HTTP_PORT_NUMBER}"
        neo4j_conf_set "server.https.listen_address" ":${NEO4J_HTTPS_PORT_NUMBER}"
        # Advertised address configuration settings
        neo4j_conf_set "server.default_advertised_address" "$host"
        neo4j_conf_set "server.bolt.advertised_address" ":${NEO4J_BOLT_ADVERTISED_PORT_NUMBER}"
        neo4j_conf_set "server.http.advertised_address" ":${NEO4J_HTTP_ADVERTISED_PORT_NUMBER}"
        neo4j_conf_set "server.https.advertised_address" ":${NEO4J_HTTPS_ADVERTISED_PORT_NUMBER}"
        # TLS settings
        neo4j_conf_set "server.bolt.tls_level" "${NEO4J_BOLT_TLS_LEVEL}"
        [[ "$NEO4J_BOLT_TLS_LEVEL" == "REQUIRED" || "$NEO4J_BOLT_TLS_LEVEL" == "OPTIONAL" ]] && neo4j_conf_set "dbms.ssl.policy.bolt.enabled" "true"
        neo4j_conf_set "server.https.enabled" "${NEO4J_HTTPS_ENABLED}"
        neo4j_conf_set "dbms.ssl.policy.https.enabled" "${NEO4J_HTTPS_ENABLED}"
    else
        error "Neo4j branch ${neo4j_major_version} not supported"
    fi
}
