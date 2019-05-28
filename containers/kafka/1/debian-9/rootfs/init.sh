#!/bin/bash

##
## @brief     Helper function to show an error when KAFKA_LISTENERS does not configure a secure listener
## param $1   Input name
##
plaintext_listener_error() {
    error "The $1 environment variable does not set a secure listener. Set the environment variable ALLOW_PLAINTEXT_LISTENER=yes to allow the container to be started with a plaintext listener. This is recommended only for development."
  exit 1
}

##
## @brief     Helper function to show a warning when the ALLOW_PLAINTEXT_LISTENER flag is enabled
##
plaintext_listener_enabled_warn() {
  warn "You set the environment variable ALLOW_PLAINTEXT_LISTENER=${ALLOW_PLAINTEXT_LISTENER}. For safety reasons, do not use this flag in a production environment."
}


# Validate passwords
if [[ "$ALLOW_PLAINTEXT_LISTENER" =~ ^(yes|Yes|YES)$ ]]; then
    plaintext_listener_enabled_warn
elif [[ ! "$KAFKA_CFG_LISTENERS" =~ SASL_SSL ]]; then
    plaintext_listener_error KAFKA_CFG_LISTENERS
fi

declare_env_alias() {
    local -r alias="${1:?missing environment variable alias}"
    local -r original="${2:?missing original environment variable}"

    if env | grep -q "${original}"; then
        export "$alias"="${!original}"
    fi
}

suffixes=(
    "ADVERTISED_LISTENERS" "BROKER_ID" "DEFAULT_REPLICATION_FACTOR" "DELETE_TOPIC_ENABLE" "INTER_BROKER_LISTENER_NAME"
    "LISTENERS" "LISTENER_SECURITY_PROTOCOL_MAP" "LOGS_DIRS" "LOG_FLUSH_INTERVAL_MESSAGES" "LOG_FLUSH_INTERVAL_MS"
    "LOG_MESSAGE_FORMAT_VERSION" "LOG_RETENTION_BYTES" "LOG_RETENTION_CHECK_INTERVALS_MS" "LOG_RETENTION_HOURS"
    "MAX_MESSAGE_BYTES" "NUM_IO_THREADS" "NUM_NETWORK_THREADS" "NUM_PARTITIONS" "NUM_RECOVERY_THREADS_PER_DATA_DIR"
    "OFFSETS_TOPIC_REPLICATION_FACTOR" "SEGMENT_BYTES" "SOCKET_RECEIVE_BUFFER_BYTES" "SOCKET_REQUEST_MAX_BYTES" "SOCKET_SEND_BUFFER_BYTES"
    "SSL_ENDPOINT_IDENTIFICATION_ALGORITHM" "TRANSACTION_STATE_LOG_MIN_ISR" "TRANSACTION_STATE_LOG_REPLICATION_FACTOR"
    "ZOOKEEPER_CONNECT" "ZOOKEEPER_CONNECT_TIMEOUT_MS"
)
for s in "${suffixes[@]}"; do
    declare_env_alias "KAFKA_CFG_${s}" "KAFKA_${s}"
done

server_properties_file="/opt/bitnami/kafka/configtmp/server.properties"
# Map environment variables to config properties
if [[ -e "$server_properties_file" ]]; then
  for var in "${!KAFKA_CFG_@}"; do
    key="$(echo "$var" | sed -e 's/^KAFKA_CFG_//g' -e 's/_/\./g' | tr '[:upper:]' '[:lower:]')"
    value="${!var}"
    if [[ -n "$value" ]]; then
      if grep -q "^#* *${key}=.*" $server_properties_file; then
        sed -i 's/^#*\s*'"$key"'=.*$/'"${key//\//\\/}=${value//\//\\/}"'/m' $server_properties_file
      else
        # shellcheck disable=SC1003
        sed -i '$a\' $server_properties_file
        echo -n "${key}=${value}" >> $server_properties_file
      fi
    fi
  done
fi
