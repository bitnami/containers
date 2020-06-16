#!/bin/bash
#
# Bitnami Spring Cloud Data Flow library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in SPRING_CLOUD_DATAFLOW_* environment variables
# Globals:
#   SPRING_CLOUD_DATAFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
dataflow_validate() {
    info "Validating settings in SPRING_CLOUD_DATAFLOW_* env vars"
    local error_code=0

    print_validation_error() {
        error "$1"
        error_code=1
    }

    if [[ "$SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API" = "true" ]]; then
        if is_empty_value "$SPRING_CLOUD_KUBERNETES_SECRETS_PATHS"; then
            print_validation_error "You set the environment variable SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API=true. A Kubernetes secrect is expected to be mounted in SPRING_CLOUD_KUBERNETES_SECRETS_PATHS."
        else
            warn "Using Kubernetes Secrets."
        fi

        is_empty_value "$SPRING_CLOUD_KUBERNETES_CONFIG_NAME" && print_validation_error "If SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API=true. You must set a ConfigMap name in SPRING_CLOUD_KUBERNETES_CONFIG_NAME."
    fi

    if [[ "$SPRING_CLOUD_DATAFLOW_FEATURES_STREAMS_ENABLED" = "true" ]]; then
        is_empty_value "$SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI" && print_validation_error "If SPRING_CLOUD_DATAFLOW_FEATURES_STREAMS_ENABLED=true then you must set a skipper server URI in SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI"
    fi

    ! is_empty_value "$SERVER_PORT" && ! validate_port -unprivileged "$SERVER_PORT" && print_validation_error "SERVER_PORT with value = ${SERVER_PORT} is not a valid port."

    [[ "$error_code" -eq 0 ]] || return "$error_code"
}

########################
# Creates Spring Cloud Data Flow default configuration file
# Globals:
#   SPRING_CLOUD_DATAFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
dataflow_create_default_config() {
    info "Creating '${SPRING_CLOUD_DATAFLOW_CONF_FILE}' as the main configuration file with default values"
    cat > "$SPRING_CLOUD_DATAFLOW_CONF_FILE" <<EOF
spring:
  cloud:
    config:
      enabled: ${SPRING_CLOUD_CONFIG_ENABLED_DEFAULT}
  datasource:
    testOnBorrow: true
    validationQuery: SELECT 1

maven:
  localRepository: ${SPRING_CLOUD_DATAFLOW_VOLUME_DIR}/.m2/repository/
EOF
}

########################
# Update Spring Cloud Data Flow configuration file with user custom inputs
# Globals:
#   SPRING_CLOUD_DATAFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
dataflow_update_custom_config() {
    ! is_empty_value "$SPRING_CLOUD_DATAFLOW_CLOUD_CONFIG_ENABLED" && dataflow_conf_set "spring.cloud.config.enabled" "$SPRING_CLOUD_DATAFLOW_CLOUD_CONFIG_ENABLED"

    if [[ "$SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API" = "false" ]]; then
        # Database setting
        ! is_empty_value "$SPRING_CLOUD_DATAFLOW_DATABASE_URL" && dataflow_conf_set "spring.datasource.url" "$SPRING_CLOUD_DATAFLOW_DATABASE_URL"
        ! is_empty_value "$SPRING_CLOUD_DATAFLOW_DATABASE_USERNAME" && dataflow_conf_set "spring.datasource.username" "$SPRING_CLOUD_DATAFLOW_DATABASE_USERNAME"
        ! is_empty_value "$SPRING_CLOUD_DATAFLOW_DATABASE_PASSWORD" && dataflow_conf_set "spring.datasource.password" "$SPRING_CLOUD_DATAFLOW_DATABASE_PASSWORD"
        ! is_empty_value "$SPRING_CLOUD_DATAFLOW_DATABASE_DRIVER" && dataflow_conf_set "spring.datasource.driver-class-name" "$SPRING_CLOUD_DATAFLOW_DATABASE_DRIVER"

        if ! is_empty_value "$SPRING_CLOUD_DATAFLOW_DATABASE_URL"; then
            is_empty_value "$SPRING_CLOUD_DATAFLOW_DATABASE_DRIVER" && dataflow_conf_set "spring.datasource.driver-class-name" "org.mariadb.jdbc.Driver"

            if [[ "$SPRING_CLOUD_DATAFLOW_DATABASE_DRIVER" = "org.mariadb.jdbc.Driver" ]] || is_empty_value "$SPRING_CLOUD_DATAFLOW_DATABASE_DRIVER"; then
                dataflow_conf_set "spring.jpa.properties.hibernate.dialect" "org.hibernate.dialect.MariaDB102Dialect"
            fi
        fi

        local -r spring_stream_prop="spring.cloud.dataflow.applicationProperties.stream"

        # Kafka settings
        local -r kafka_prop="${spring_stream_prop}.spring.cloud.stream.kafka"
        ! is_empty_value "$SPRING_CLOUD_DATAFLOW_STREAM_KAFKA_URI" && dataflow_conf_set "${kafka_prop}.binder.brokers" "$SPRING_CLOUD_DATAFLOW_STREAM_KAFKA_URI" && \
            dataflow_conf_set "${kafka_prop}.streams.binder.brokers" "$SPRING_CLOUD_DATAFLOW_STREAM_KAFKA_URI"
        ! is_empty_value "$SPRING_CLOUD_DATAFLOW_STREAM_ZOOKEEPER_URI" && dataflow_conf_set "${kafka_prop}.binder.zkNodes" "$SPRING_CLOUD_DATAFLOW_STREAM_ZOOKEEPER_URI" && \
            dataflow_conf_set "${kafka_prop}.streams.binder.zkNodes" "$SPRING_CLOUD_DATAFLOW_STREAM_ZOOKEEPER_URI"

        # RabbitMQ settings
        local -r rabbitmq_prop="${spring_stream_prop}.spring.rabbitmq"
        ! is_empty_value "$SPRING_CLOUD_DATAFLOW_STREAM_RABBITMQ_HOST" && dataflow_conf_set "${rabbitmq_prop}.host" "$SPRING_CLOUD_DATAFLOW_STREAM_RABBITMQ_HOST"
        ! is_empty_value "$SPRING_CLOUD_DATAFLOW_STREAM_RABBITMQ_PORT" && dataflow_conf_set "${rabbitmq_prop}.port" "$SPRING_CLOUD_DATAFLOW_STREAM_RABBITMQ_PORT"
        ! is_empty_value "$SPRING_CLOUD_DATAFLOW_STREAM_RABBITMQ_USERNAME" && dataflow_conf_set "${rabbitmq_prop}.username" "$SPRING_CLOUD_DATAFLOW_STREAM_RABBITMQ_USERNAME"
        ! is_empty_value "$SPRING_CLOUD_DATAFLOW_STREAM_RABBITMQ_PASSWORD" && dataflow_conf_set "${rabbitmq_prop}.password" "$SPRING_CLOUD_DATAFLOW_STREAM_RABBITMQ_PASSWORD"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the Spring Cloud Data Flow configuration file ("$SPRING_CLOUD_DATAFLOW_CONF_FILE")
# Globals:
#   SPRING_CLOUD_DATAFLOW_*
# Arguments:
#   $1 - Spring Cloud Data Flow variable name
#   $2 - Value to assign to the Spring Cloud Data Flow variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
dataflow_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"

    info "Setting ${key} option"
    debug "Setting ${key} to '${value}' in dataflow configuration"

    yq w -i "$SPRING_CLOUD_DATAFLOW_CONF_FILE" "${key}" "${value}"
}

########################
# Ensure Spring Cloud Data Flow is initialized
# Globals:
#   SPRING_CLOUD_DATAFLOW_*
# Arguments:
#   None
# Returns:
#   None
#########################
dataflow_initialize() {
    if is_file_writable "$SPRING_CLOUD_DATAFLOW_CONF_FILE"; then
        info "Updating '${SPRING_CLOUD_DATAFLOW_CONF_FILE}' with custom configuration"
        dataflow_update_custom_config
    else
        warn "The Spring Cloud Data Flow configuration file '${SPRING_CLOUD_DATAFLOW_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."
    fi
}
