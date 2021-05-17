#!/bin/bash
#
# Bitnami Keycloak library

# shellcheck disable=SC1090,SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in KEYCLOAK_* env. variables
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_validate() {
    info "Validating settings in KEYCLOAK_* env vars..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_allowed_port() {
        local port_var="${1:?missing port variable}"
        local -a validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        validate_port_args+=("${!port_var}")
        if ! err=$(validate_port "${validate_port_args[@]}"); then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    if is_boolean_yes "$KEYCLOAK_ENABLE_TLS"; then
        if is_empty_value "$KEYCLOAK_TLS_TRUSTSTORE_FILE"; then
            print_validation_error "Path to the TLS truststore file not defined. Please set the KEYCLOAK_TLS_TRUSTSTORE_FILE variable to the mounted truststore"
        fi
        if is_empty_value "$KEYCLOAK_TLS_KEYSTORE_FILE"; then
            print_validation_error "Path to the TLS keystore file not defined. Please set the KEYCLOAK_TLS_KEYSTORE_FILE variable to the mounted keystore"
        fi
    fi

    if ! validate_ipv4 "${KEYCLOAK_BIND_ADDRESS}"; then
        if ! is_hostname_resolved "${KEYCLOAK_BIND_ADDRESS}"; then
            print_validation_error print_validation_error "The value for KEYCLOAK_BIND_ADDRESS ($KEYCLOAK_BIND_ADDRESS) should be an IPv4 address or it must be a resolvable hostname"
        fi
    fi

    if ! is_empty_value "$KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL" && is_empty_value "$KEYCLOAK_JGROUPS_TRANSPORT_STACK"; then
        print_validation_error "jgroups discovery protocol configured but transport stack not set. Please set the KEYCLOAK_JGROUPS_TRANSPORT_STACK variable with the proper stack"
    fi

    if [[ "$KEYCLOAK_HTTP_PORT" -eq "$KEYCLOAK_HTTPS_PORT" ]]; then
        print_validation_error "KEYCLOAK_HTTP_PORT and KEYCLOAK_HTTPS_PORT are bound to the same port!"
    fi
    check_allowed_port KEYCLOAK_HTTP_PORT
    check_allowed_port KEYCLOAK_HTTPS_PORT

    for var in KEYCLOAK_CREATE_ADMIN_USER KEYCLOAK_ENABLE_TLS KEYCLOAK_ENABLE_STATISTICS; do
        if ! is_true_false_value "${!var}"; then
            print_validation_error "The allowed values for $var are [true, false]"
        fi
    done

    for var in KEYCLOAK_INIT_MAX_RETRIES KEYCLOAK_CACHE_OWNERS_COUNT KEYCLOAK_AUTH_CACHE_OWNERS_COUNT; do
        if ! is_positive_int "${!var}"; then
            print_validation_error "The variable $var must be positive integer"
        fi
    done

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Configure database settings using JBoss CLI
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_database() {
    info "Configuring database settings"
    debug_execute jboss-cli.sh <<EOF
embed-server --server-config=${KEYCLOAK_CONF_FILE} --std-out=echo
batch
/subsystem=datasources/data-source=KeycloakDS: remove()
/subsystem=datasources/data-source=KeycloakDS: add(jndi-name=java:jboss/datasources/KeycloakDS,enabled=true,use-java-context=true,use-ccm=true, connection-url=jdbc:postgresql://${KEYCLOAK_DATABASE_HOST}:${KEYCLOAK_DATABASE_PORT}/${KEYCLOAK_DATABASE_NAME}, driver-name=postgresql)
/subsystem=datasources/data-source=KeycloakDS: write-attribute(name=user-name, value=${KEYCLOAK_DATABASE_USER})
/subsystem=datasources/data-source=KeycloakDS: write-attribute(name=check-valid-connection-sql, value="SELECT 1")
/subsystem=datasources/data-source=KeycloakDS: write-attribute(name=background-validation, value=true)
/subsystem=datasources/data-source=KeycloakDS: write-attribute(name=background-validation-millis, value=60000)
/subsystem=datasources/data-source=KeycloakDS: write-attribute(name=flush-strategy, value=IdleConnections)
/subsystem=datasources/jdbc-driver=postgresql:add(driver-name=postgresql, driver-module-name=org.postgresql.jdbc, driver-xa-datasource-class-name=org.postgresql.xa.PGXADataSource)
/subsystem=keycloak-server/spi=connectionsJpa/provider=default:write-attribute(name=properties.schema,value=${KEYCLOAK_DATABASE_SCHEMA})
run-batch
stop-embedded-server
EOF

    if ! is_empty_value "$KEYCLOAK_DATABASE_PASSWORD"; then
        debug_execute jboss-cli.sh <<EOF
embed-server --server-config=${KEYCLOAK_CONF_FILE} --std-out=echo
batch
/subsystem=datasources/data-source=KeycloakDS: write-attribute(name=password, value=${KEYCLOAK_DATABASE_PASSWORD})
run-batch
stop-embedded-server
EOF
    fi
}

########################
# Configure JGroups settings using JBoss CLI
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_jgroups() {
    info "Configuring jgroups settings"
    if [[ "$KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL" == "JDBC_PING" ]]; then
        debug_execute jboss-cli.sh <<EOF
embed-server --server-config=${KEYCLOAK_CONF_FILE} --std-out=echo
batch
/subsystem=jgroups/stack=udp/protocol=PING:remove()
/subsystem=jgroups/stack=udp/protocol=JDBC_PING:add(add-index=0, data-source=KeycloakDS, properties={${KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES}})
/subsystem=jgroups/stack=tcp/protocol=MPING:remove()
/subsystem=jgroups/stack=tcp/protocol=JDBC_PING:add(add-index=0, data-source=KeycloakDS, properties={${KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES}})
/subsystem=jgroups/channel=ee:write-attribute(name="stack", value=${KEYCLOAK_JGROUPS_TRANSPORT_STACK})
run-batch
stop-embedded-server
EOF
    else
        debug_execute jboss-cli.sh <<EOF
embed-server --server-config=${KEYCLOAK_CONF_FILE} --std-out=echo
batch
/subsystem=jgroups/stack=udp/protocol=PING:remove()
/subsystem=jgroups/stack=udp/protocol=${KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL}:add(add-index=0, properties={${KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES}})
/subsystem=jgroups/stack=tcp/protocol=MPING:remove()
/subsystem=jgroups/stack=tcp/protocol=${KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL}:add(add-index=0, properties={${KEYCLOAK_JGROUPS_DISCOVERY_PROPERTIES}})
/subsystem=jgroups/channel=ee:write-attribute(name="stack", value=${KEYCLOAK_JGROUPS_TRANSPORT_STACK})
run-batch
stop-embedded-server
EOF
    fi
}

########################
# Configure cluster caching using JBoss CLI
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_cache() {
    info "Configuring cache count"
    debug_execute jboss-cli.sh <<EOF
embed-server --server-config=${KEYCLOAK_CONF_FILE} --std-out=echo
batch
/subsystem=infinispan/cache-container=keycloak/distributed-cache=sessions: write-attribute(name=owners, value=${KEYCLOAK_CACHE_OWNERS_COUNT})
/subsystem=infinispan/cache-container=keycloak/distributed-cache=offlineSessions: write-attribute(name=owners, value=${KEYCLOAK_CACHE_OWNERS_COUNT})
/subsystem=infinispan/cache-container=keycloak/distributed-cache=loginFailures: write-attribute(name=owners, value=${KEYCLOAK_CACHE_OWNERS_COUNT})
/subsystem=infinispan/cache-container=keycloak/distributed-cache=clientSessions: write-attribute(name=owners, value=${KEYCLOAK_CACHE_OWNERS_COUNT})
/subsystem=infinispan/cache-container=keycloak/distributed-cache=actionTokens: write-attribute(name=owners, value=${KEYCLOAK_CACHE_OWNERS_COUNT})
/subsystem=infinispan/cache-container=keycloak/distributed-cache=offlineClientSessions: write-attribute(name=owners, value=${KEYCLOAK_CACHE_OWNERS_COUNT})
run-batch
stop-embedded-server
EOF
}

########################
# Configure cluster authentication caching using JBoss CLI
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_auth_cache() {
    info "Configuring authentication cache count"
    debug_execute jboss-cli.sh <<EOF
embed-server --server-config=${KEYCLOAK_CONF_FILE} --std-out=echo
batch
/subsystem=infinispan/cache-container=keycloak/distributed-cache=authenticationSessions: write-attribute(name=owners, value=${KEYCLOAK_AUTH_CACHE_OWNERS_COUNT})
run-batch
stop-embedded-server
EOF
}

########################
# Enable statistics using JBoss CLI
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_statistics() {
    info "Enabling statistics"
    debug_execute jboss-cli.sh <<EOF
embed-server --server-config=${KEYCLOAK_CONF_FILE} --std-out=echo
batch
/subsystem=datasources/data-source=KeycloakDS:write-attribute(name=statistics-enabled, value=true)
/subsystem=undertow:write-attribute(name=statistics-enabled,value=true)
/subsystem=jgroups/channel=ee:write-attribute(name=statistics-enabled, value=true)
run-batch
stop-embedded-server
EOF
}

########################
# Configure database settings using JBoss CLI
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_tls() {
    info "Configuring TLS by setting keystore and truststore"
    debug_execute jboss-cli.sh <<EOF
embed-server --server-config=${KEYCLOAK_CONF_FILE} --std-out=discard
batch
/subsystem=elytron/key-store=kcKeyStore:add(path=${KEYCLOAK_TLS_KEYSTORE_FILE},type=JKS,credential-reference={clear-text=${KEYCLOAK_TLS_KEYSTORE_PASSWORD}})
/subsystem=elytron/key-manager=kcKeyManager:add(key-store=kcKeyStore,credential-reference={clear-text=${KEYCLOAK_TLS_KEYSTORE_PASSWORD}})
/subsystem=elytron/server-ssl-context=kcSSLContext:add(key-manager=kcKeyManager)
/subsystem=undertow/server=default-server/https-listener=https:undefine-attribute(name=security-realm)
/subsystem=undertow/server=default-server/https-listener=https:write-attribute(name=ssl-context,value=kcSSLContext)
/subsystem=elytron/key-store=kcTrustStore:add(path=${KEYCLOAK_TLS_TRUSTSTORE_FILE},type=JKS,credential-reference={clear-text=${KEYCLOAK_TLS_TRUSTSTORE_PASSWORD}})
/subsystem=elytron/trust-manager=kcTrustManager:add(key-store=kcTrustStore)
/subsystem=elytron/server-ssl-context=kcSSLContext:write-attribute(name=trust-manager, value=kcTrustManager)
/subsystem=elytron/server-ssl-context=kcSSLContext:write-attribute(name=want-client-auth, value=true)
/subsystem=keycloak-server/spi=truststore/:add
/subsystem=keycloak-server/spi=truststore/provider=file/:add(enabled=true,properties={file => ${KEYCLOAK_TLS_TRUSTSTORE_FILE}, password => ${KEYCLOAK_TLS_TRUSTSTORE_PASSWORD}, hostname-verification-policy => "WILDCARD", disabled => "false"})
run-batch
stop-embedded-server
EOF
}

########################
# Configure logging settings using JBoss CLI
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_loglevel() {
    info "Configuring log level"
    debug_execute jboss-cli.sh <<EOF
embed-server --server-config=${KEYCLOAK_CONF_FILE} --std-out=discard
batch
/subsystem=logging/logger=org.keycloak:add
/subsystem=logging/logger=org.keycloak:write-attribute(name=level,value=${KEYCLOAK_LOG_LEVEL})
/subsystem=logging/root-logger=ROOT:change-root-log-level(level=${KEYCLOAK_ROOT_LOG_LEVEL})
/subsystem=logging/root-logger=ROOT:remove-handler(name="FILE")
/subsystem=logging/periodic-rotating-file-handler=FILE:remove
/subsystem=logging/console-handler=CONSOLE:undefine-attribute(name=level)
run-batch
stop-embedded-server
EOF
}

########################
# Clean when restarting the container
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_clean_from_restart() {
    # If we do not remove this history several errors will appear in the installation logs
    if [[ -d "${KEYCLOAK_CONF_DIR}/standalone_xml_history" ]]; then
        info "Removing configuration history"
        rm -r "${KEYCLOAK_CONF_DIR}/standalone_xml_history"
    fi
    # These files should be removed to avoid issues when running docker restart
    if [[ -f "${KEYCLOAK_CONF_DIR}/${KEYCLOAK_CONF_FILE}" ]]; then
        info "Removing configuration file"
        rm "${KEYCLOAK_CONF_DIR}/${KEYCLOAK_CONF_FILE}"
    fi

    if [[ -f "${KEYCLOAK_CONF_DIR}/keycloak-add-user.json" ]]; then
        info "Removing add users file"
        rm "${KEYCLOAK_CONF_DIR}/keycloak-add-user.json"
    fi
}

########################
# Configure proxy settings using JBoss CLI
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_proxy() {
    info "Configuring proxy address forwarding"
    debug_execute jboss-cli.sh <<EOF
embed-server --server-config=${KEYCLOAK_CONF_FILE} --std-out=discard
batch
/subsystem=undertow/server=default-server/http-listener=default: write-attribute(name=proxy-address-forwarding, value=${KEYCLOAK_PROXY_ADDRESS_FORWARDING})
/subsystem=undertow/server=default-server/https-listener=https: write-attribute(name=proxy-address-forwarding, value=${KEYCLOAK_PROXY_ADDRESS_FORWARDING})
run-batch
stop-embedded-server
EOF
}

########################
# Configure node identifier
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_node_identifier() {
    info "Configuring node identifier"
    debug_execute jboss-cli.sh <<EOF
embed-server --server-config=${KEYCLOAK_CONF_FILE} --std-out=echo
batch
/subsystem=transactions:write-attribute(name=node-identifier, value=\${jboss.node.name})
run-batch
stop-embedded-server
EOF
}

########################
# Initialize keycloak installation
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_initialize() {
    # Clean to avoid issues when running docker restart
    keycloak_clean_from_restart
    # Wait for database
    info "Trying to connect to PostgreSQL server $KEYCLOAK_DATABASE_HOST..."
    if ! retry_while "wait-for-port --host $KEYCLOAK_DATABASE_HOST --timeout 10 $KEYCLOAK_DATABASE_PORT" "$KEYCLOAK_INIT_MAX_RETRIES"; then
        error "Unable to connect to host $KEYCLOAK_DATABASE_HOST"
        exit 1
    else
        info "Found PostgreSQL server listening at $KEYCLOAK_DATABASE_HOST:$KEYCLOAK_DATABASE_PORT"
    fi

    if ! is_dir_empty "$KEYCLOAK_MOUNTED_CONF_DIR"; then
        cp -Lr "$KEYCLOAK_MOUNTED_CONF_DIR"/* "$KEYCLOAK_CONF_DIR"
    fi
    if [[ -f "${KEYCLOAK_CONF_DIR}/${KEYCLOAK_CONF_FILE}" ]]; then
        debug "Injected configuration file found. Skipping default configuration"
    else
        cp "${KEYCLOAK_CONF_DIR}/${KEYCLOAK_DEFAULT_CONF_FILE}" "${KEYCLOAK_CONF_DIR}/${KEYCLOAK_CONF_FILE}"

        # Configure settings using jboss-cli.sh
        keycloak_configure_database
        if is_boolean_yes "$KEYCLOAK_CREATE_ADMIN_USER"; then
            debug_execute add-user-keycloak.sh -u "$KEYCLOAK_ADMIN_USER" -p "$KEYCLOAK_ADMIN_PASSWORD"
        fi
        ! is_empty_value "$KEYCLOAK_JGROUPS_DISCOVERY_PROTOCOL" && keycloak_configure_jgroups
        keycloak_configure_cache
        keycloak_configure_auth_cache
        debug_execute add-user.sh -u "$KEYCLOAK_MANAGEMENT_USER" -p "$KEYCLOAK_MANAGEMENT_PASSWORD"
        is_boolean_yes "$KEYCLOAK_ENABLE_STATISTICS" && keycloak_configure_statistics
        is_boolean_yes "$KEYCLOAK_ENABLE_TLS" && keycloak_configure_tls
        keycloak_configure_loglevel
        keycloak_configure_proxy
        keycloak_configure_node_identifier
    fi

    debug "Ensuring expected directories/files exist..."
    for dir in "$KEYCLOAK_LOG_DIR" "$KEYCLOAK_TMP_DIR" "$KEYCLOAK_DATA_DIR" "$KEYCLOAK_CONF_DIR" "$KEYCLOAK_DEPLOYMENTS_DIR" "$KEYCLOAK_DOMAIN_TMP_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown -R "$KEYCLOAK_DAEMON_USER:$KEYCLOAK_DAEMON_GROUP" "$dir"
    done

    true
}

########################
# Run custom initialization scripts
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_custom_init_scripts() {
    if [[ -n $(find "${KEYCLOAK_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh") ]] && [[ ! -f "${KEYCLOAK_INITSCRIPTS_DIR}/.user_scripts_initialized" ]]; then
        info "Loading user's custom files from ${KEYCLOAK_INITSCRIPTS_DIR} ..."
        local -r tmp_file="/tmp/filelist"
        find "${KEYCLOAK_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh" | sort >"$tmp_file"
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
        touch "$KEYCLOAK_VOLUME_DIR"/.user_scripts_initialized
    fi
}
