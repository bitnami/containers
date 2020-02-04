#!/bin/bash
#
# Bitnami Kafka library

# shellcheck disable=SC1091

# Load Generic Libraries
. /libfile.sh
. /liblog.sh
. /libos.sh
. /libvalidations.sh

# Functions

########################
# Set a configuration setting value to a file
# Globals:
#   None
# Arguments:
#   $1 - file
#   $2 - key
#   $3 - values (array)
# Returns:
#   None
#########################
kafka_common_conf_set() {
    local file="${1:?missing file}"
    local key="${2:?missing key}"
    shift
    shift
    local values=("$@")

    if [[ "${#values[@]}" -eq 0 ]]; then
        stderr_print "missing value"
        return 1
    elif [[ "${#values[@]}" -ne 1 ]]; then
        for i in "${!values[@]}"; do
            kafka_common_conf_set "$file" "${key[$i]}" "${values[$i]}"
        done
    else
        value="${values[0]}"
        # Check if the value was set before
        if grep -q "^[#\\s]*$key\s*=.*" "$file"; then
            # Update the existing key
            replace_in_file "$file" "^[#\\s]*${key}\s*=.*" "${key}=${value}" false
        else
            # Add a new key
            printf '\n%s=%s' "$key" "$value" >>"$file"
        fi
    fi
}

########################
# Set a configuration setting value to server.properties
# Globals:
#   KAFKA_CONF_FILE
# Arguments:
#   $1 - key
#   $2 - values (array)
# Returns:
#   None
#########################
kafka_server_conf_set() {
    kafka_common_conf_set "$KAFKA_CONF_FILE" "$@"
}

########################
# Set a configuration setting value to producer.properties and consumer.properties
# Globals:
#   KAFKA_CONFDIR
# Arguments:
#   $1 - key
#   $2 - values (array)
# Returns:
#   None
#########################
kafka_producer_consumer_conf_set() {
    kafka_common_conf_set "$KAFKA_CONFDIR/producer.properties" "$@"
    kafka_common_conf_set "$KAFKA_CONFDIR/consumer.properties" "$@"
}

########################
# Load global variables used on Kafka configuration
# Globals:
#   KAFKA_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
kafka_env() {
    cat <<"EOF"
export KAFKA_BASEDIR="/opt/bitnami/kafka"
export KAFKA_HOME="$KAFKA_BASEDIR"
export KAFKA_LOGDIR="$KAFKA_BASEDIR"/logs
export KAFKA_CONFDIR="$KAFKA_BASEDIR"/conf
export KAFKA_CONF_FILE_NAME="server.properties"
export KAFKA_CONF_FILE="$KAFKA_CONFDIR"/$KAFKA_CONF_FILE_NAME
export KAFKA_VOLUMEDIR="/bitnami/kafka"
export KAFKA_DATADIR="$KAFKA_VOLUMEDIR"/data
export KAFKA_DAEMON_USER="kafka"
export KAFKA_DAEMON_GROUP="kafka"
export PATH="${KAFKA_BASEDIR}/bin:$PATH"
export ALLOW_PLAINTEXT_LISTENER="${ALLOW_PLAINTEXT_LISTENER:-no}"
export KAFKA_INTER_BROKER_USER="${KAFKA_INTER_BROKER_USER:-user}"
export KAFKA_INTER_BROKER_PASSWORD="${KAFKA_INTER_BROKER_PASSWORD:-bitnami}"
export KAFKA_BROKER_USER="${KAFKA_BROKER_USER:-user}"
export KAFKA_BROKER_PASSWORD="${KAFKA_BROKER_PASSWORD:-bitnami}"
export KAFKA_HEAP_OPTS="${KAFKA_HEAP_OPTS:-"-Xmx1024m -Xms1024m"}"
export KAFKA_PORT_NUMBER="${KAFKA_PORT_NUMBER:-9092}"
export KAFKA_ZOOKEEPER_PASSWORD="${KAFKA_ZOOKEEPER_PASSWORD:-}"
export KAFKA_ZOOKEEPER_USER="${KAFKA_ZOOKEEPER_USER:-}"
export KAFKA_CFG_ADVERTISED_LISTENERS="${KAFKA_CFG_ADVERTISED_LISTENERS:-"PLAINTEXT://:9092"}"
export KAFKA_CFG_LISTENERS="${KAFKA_CFG_LISTENERS:-"PLAINTEXT://:9092"}"
export KAFKA_CFG_ZOOKEEPER_CONNECT="${KAFKA_CFG_ZOOKEEPER_CONNECT:-"localhost:2181"}"
EOF
}

########################
# Create alias for environment variable, so both can be used
# Globals:
#   None
# Arguments:
#   $1 - Alias environment variable name
#   $2 - Original environment variable name
# Returns:
#   None
#########################
kafka_declare_alias_env() {
    local -r alias="${1:?missing environment variable alias}"
    local -r original="${2:?missing original environment variable}"
    if printenv "${original}" > /dev/null; then
        export "$alias"="${!original:-}"
    fi
}

########################
# Map Kafka legacy environment variables to the new names
# Globals:
#   KAFKA_*
# Arguments:
#   None
# Returns:
#   None
#########################
kafka_create_alias_environment_variables() {
    suffixes=(
        "ADVERTISED_LISTENERS"
        "BROKER_ID"
        "DEFAULT_REPLICATION_FACTOR"
        "DELETE_TOPIC_ENABLE"
        "INTER_BROKER_LISTENER_NAME"
        "LISTENERS"
        "LISTENER_SECURITY_PROTOCOL_MAP"
        "LOG_DIRS"
        "LOG_FLUSH_INTERVAL_MESSAGES"
        "LOG_FLUSH_INTERVAL_MS"
        "LOG_MESSAGE_FORMAT_VERSION"
        "LOG_RETENTION_BYTES"
        "LOG_RETENTION_CHECK_INTERVALS_MS"
        "LOG_RETENTION_HOURS"
        "LOG_SEGMENT_BYTES"
        "MESSAGE_MAX_BYTES"
        "NUM_IO_THREADS"
        "NUM_NETWORK_THREADS"
        "NUM_PARTITIONS"
        "NUM_RECOVERY_THREADS_PER_DATA_DIR"
        "OFFSETS_TOPIC_REPLICATION_FACTOR"
        "SOCKET_RECEIVE_BUFFER_BYTES"
        "SOCKET_REQUEST_MAX_BYTES"
        "SOCKET_SEND_BUFFER_BYTES"
        "SSL_ENDPOINT_IDENTIFICATION_ALGORITHM"
        "TRANSACTION_STATE_LOG_MIN_ISR"
        "TRANSACTION_STATE_LOG_REPLICATION_FACTOR"
        "ZOOKEEPER_CONNECT"
        "ZOOKEEPER_CONNECTION_TIMEOUT_MS"
    )
    kafka_declare_alias_env "KAFKA_CFG_LOG_DIRS" "KAFKA_LOGS_DIRS"
    kafka_declare_alias_env "KAFKA_CFG_LOG_SEGMENT_BYTES" "KAFKA_SEGMENT_BYTES"
    kafka_declare_alias_env "KAFKA_CFG_MESSAGE_MAX_BYTES" "KAFKA_MAX_MESSAGE_BYTES"
    kafka_declare_alias_env "KAFKA_CFG_PORT" "KAFKA_PORT_NUMBER"
    kafka_declare_alias_env "KAFKA_CFG_ZOOKEEPER_CONNECTION_TIMEOUT_MS" "KAFKA_ZOOKEEPER_CONNECT_TIMEOUT_MS"
    for s in "${suffixes[@]}"; do
        kafka_declare_alias_env "KAFKA_CFG_${s}" "KAFKA_${s}"
    done
}

########################
# Validate settings in KAFKA_* env vars
# Globals:
#   KAFKA_*
# Arguments:
#   None
# Returns:
#   None
#########################
kafka_validate() {
    debug "Validating settings in KAFKA_* env vars..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    local validate_port_args=()
    ! am_i_root && validate_port_args+=("-unprivileged")
    for var in "KAFKA_PORT_NUMBER"; do
        if ! err=$(validate_port "${validate_port_args[@]}" "${!var}"); then
            print_validation_error "An invalid port was specified in the environment variable $var: $err"
        fi
    done
    if is_boolean_yes "$ALLOW_PLAINTEXT_LISTENER"; then
        warn "You set the environment variable ALLOW_PLAINTEXT_LISTENER=$ALLOW_PLAINTEXT_LISTENER. For safety reasons, do not use this flag in a production environment."
    fi
    if [[ "${KAFKA_CFG_LISTENERS:-}" =~ SASL_SSL ]] || [[ "${KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP:-}" =~ SASL_SSL ]]; then
        if [[ ! -f "$KAFKA_CONFDIR"/certs/kafka.keystore.jks ]] || [[ ! -f "$KAFKA_CONFDIR"/certs/kafka.truststore.jks ]]; then
            print_validation_error "In order to configure the SASL_SSL listener for Kafka you must mount your kafka.keystore.jks and kafka.truststore.jks certificates to the $KAFKA_CONFDIR/certs directory."
        fi
    elif ! is_boolean_yes "$ALLOW_PLAINTEXT_LISTENER"; then
        print_validation_error "The KAFKA_CFG_LISTENERS environment variable does not configure a secure listener. Set the environment variable ALLOW_PLAINTEXT_LISTENER=yes to allow the container to be started with a plaintext listener. This is only recommended for development."
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Generate JAAS authentication files
# Globals:
#   KAFKA_*
# Arguments:
#   None
# Returns:
#   None
#########################
kafka_generate_jaas_authentication_file() {
    render-template >"$KAFKA_CONFDIR"/kafka_jaas.conf <<EOF
KafkaClient {
   org.apache.kafka.common.security.plain.PlainLoginModule required
   username="{{KAFKA_BROKER_USER}}"
   password="{{KAFKA_BROKER_PASSWORD}}";
};

KafkaServer {
   org.apache.kafka.common.security.plain.PlainLoginModule required
   username="{{KAFKA_INTER_BROKER_USER}}"
   password="{{KAFKA_INTER_BROKER_PASSWORD}}"
   user_{{KAFKA_INTER_BROKER_USER}}="{{KAFKA_INTER_BROKER_PASSWORD}}"
   user_{{KAFKA_BROKER_USER}}="{{KAFKA_BROKER_PASSWORD}}";

   org.apache.kafka.common.security.scram.ScramLoginModule required;
};
EOF
    if [[ -n "$KAFKA_ZOOKEEPER_USER" ]] && [[ -n "$KAFKA_ZOOKEEPER_PASSWORD" ]]; then
        info "Configuring ZooKeeper client credentials"
        render-template >>"$KAFKA_CONFDIR"/kafka_jaas.conf <<EOF

Client {
   org.apache.kafka.common.security.plain.PlainLoginModule required
   username="{{KAFKA_ZOOKEEPER_USER}}"
   password="{{KAFKA_ZOOKEEPER_PASSWORD}}";
};
EOF
    fi
}

########################
# Configure Kafka SASL_SSL listener
# Globals:
#   KAFKA_CERTIFICATE_PASSWORD
#   KAFKA_CONFDIR
#   KAFKA_CONF_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
kafka_configure_sasl_ssl_listener() {
    info "SASL_SSL listener detected, enabling SASL_SSL settings"
    kafka_generate_jaas_authentication_file
    # Set Kafka configuration
    kafka_server_conf_set ssl.keystore.location "$KAFKA_CONFDIR"/certs/kafka.keystore.jks
    kafka_server_conf_set ssl.keystore.password "$KAFKA_CERTIFICATE_PASSWORD"
    kafka_server_conf_set ssl.key.password "$KAFKA_CERTIFICATE_PASSWORD"
    kafka_server_conf_set ssl.truststore.location "$KAFKA_CONFDIR"/certs/kafka.truststore.jks
    kafka_server_conf_set ssl.truststore.password "$KAFKA_CERTIFICATE_PASSWORD"
    kafka_server_conf_set sasl.mechanism.inter.broker.protocol PLAIN
    kafka_server_conf_set sasl.enabled.mechanisms PLAIN,SCRAM-SHA-256,SCRAM-SHA-512
    kafka_server_conf_set security.inter.broker.protocol SASL_SSL
    kafka_server_conf_set ssl.client.auth required
    # Set producer/consumer configuration
    kafka_producer_consumer_conf_set ssl.keystore.location "$KAFKA_CONFDIR"/certs/kafka.keystore.jks
    kafka_producer_consumer_conf_set ssl.keystore.password "$KAFKA_CERTIFICATE_PASSWORD"
    kafka_producer_consumer_conf_set ssl.truststore.location "$KAFKA_CONFDIR"/certs/kafka.truststore.jks
    kafka_producer_consumer_conf_set ssl.truststore.password "$KAFKA_CERTIFICATE_PASSWORD"
    kafka_producer_consumer_conf_set ssl.key.password "$KAFKA_CERTIFICATE_PASSWORD"
    kafka_producer_consumer_conf_set security.protocol SASL_SSL
    kafka_producer_consumer_conf_set sasl.mechanism PLAIN
}

########################
# Configure Kafka SASL_PLAINTEXT listener
# Globals:
#   KAFKA_CONF_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
kafka_configure_sasl_plaintext_listener() {
    info "SASL_PLAINTEXT listener detected, enabling SASL_PLAINTEXT settings"
    kafka_generate_jaas_authentication_file
    # Set Kafka configuration
    kafka_server_conf_set sasl.mechanism.inter.broker.protocol PLAIN
    kafka_server_conf_set sasl.enabled.mechanisms PLAIN,SCRAM-SHA-256,SCRAM-SHA-512
    kafka_server_conf_set security.inter.broker.protocol SASL_PLAINTEXT
    # Set producer/consumer configuration
    kafka_producer_consumer_conf_set security.protocol SASL_SSL
    kafka_producer_consumer_conf_set sasl.mechanism PLAIN
}

########################
# Configure Kafka configuration files from environment variables
# Globals:
#   KAFKA_*
# Arguments:
#   None
# Returns:
#   None
#########################
kafka_configure_from_environment_variables() {
    # Map environment variables to config properties
    for var in "${!KAFKA_CFG_@}"; do
        key="$(echo "$var" | sed -e 's/^KAFKA_CFG_//g' -e 's/_/\./g' | tr '[:upper:]' '[:lower:]')"
        value="${!var}"
        kafka_server_conf_set "$key" "$value"
    done
}

########################
# Initialize Kafka
# Globals:
#   KAFKA_*
# Arguments:
#   None
# Returns:
#   None
#########################
kafka_initialize() {
    # Since we remove this directory afterwards, it allows us to check if Kafka had already been initialized
    if [[ ! -d "$KAFKA_BASEDIR"/configtmp ]]; then
        info "Kafka has already been initialized"
        return
    fi

    info "Initializing Kafka..."

    # Check for mounted configuration files
    cp -r "$KAFKA_BASEDIR"/config/. "$KAFKA_CONFDIR"
    rm -rf "$KAFKA_BASEDIR"/config
    if [[ ! -f "$KAFKA_CONF_FILE" ]]; then
        info "No injected configuration files found, creating default config files"
        cp -r "$KAFKA_BASEDIR"/configtmp/. "$KAFKA_CONFDIR"
        kafka_server_conf_set log.dirs "$KAFKA_DATADIR"
        kafka_configure_from_environment_variables
        if [[ "${KAFKA_CFG_LISTENERS:-}" =~ SASL_SSL ]] || [[ "${KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP:-}" =~ SASL_SSL ]]; then
            kafka_configure_sasl_ssl_listener
        elif [[ "${KAFKA_CFG_LISTENERS:-}" =~ SASL_PLAINTEXT ]] || [[ "${KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP:-}" =~ SASL_PLAINTEXT ]]; then
            kafka_configure_sasl_plaintext_listener
        fi

        # Remove security.inter.broker.protocol if KAFKA_CFG_INTER_BROKER_LISTENER_NAME is configured
        if [[ ! -z "${KAFKA_CFG_INTER_BROKER_LISTENER_NAME:-}" ]]; then
            remove_in_file "$KAFKA_CONF_FILE" "security.inter.broker.protocol" false
        fi
    fi
    rm -rf "$KAFKA_BASEDIR"/configtmp
    ln -s "$KAFKA_CONFDIR" "$KAFKA_BASEDIR"/config
}

########################
# Run custom initialization scripts
# Globals:
#   KAFKA_*
# Arguments:
#   None
# Returns:
#   None
#########################
kafka_custom_init_scripts() {
    if [[ -n $(find /docker-entrypoint-initdb.d/ -type f -regex ".*\.\(sh\)") ]] && [[ ! -f "$KAFKA_VOLUMEDIR/.user_scripts_initialized" ]] ; then
        info "Loading user's custom files from /docker-entrypoint-initdb.d";
        for f in /docker-entrypoint-initdb.d/*; do
            debug "Executing $f"
            case "$f" in
                *.sh)
                    if [[ -x "$f" ]]; then
                        if ! "$f"; then
                            error "Failed executing $f"
                            return 1
                        fi
                    else
                        warn "Sourcing $f as it is not executable by the current user, any error may cause initialization to fail"
                        . "$f"
                    fi
                    ;;
                *)
                    warn "Skipping $f, supported formats are: .sh"
                    ;;
            esac
        done
        touch "$KAFKA_VOLUMEDIR"/.user_scripts_initialized
    fi
}
