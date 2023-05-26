#!/bin/bash
#
# Bitnami Spark library

# shellcheck disable=SC1091

# Load Libraries
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libfile.sh

# Functions

########################
# Validate settings in SPARK_* env vars
# Globals:
#   SPARK_*
# Arguments:
#   None
# Returns:
#   None
#########################
spark_validate() {
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    # Validate spark mode
    case "$SPARK_MODE" in
    master | worker) ;;

    *)
        print_validation_error "Invalid mode $SPARK_MODE. Supported types are 'master/worker'"
        ;;
    esac

    # Validate metrics enabled
    if ! is_true_false_value "$SPARK_METRICS_ENABLED"; then
        print_validation_error "Valid values for SPARK_METRICS_ENABLED are: true or false"
    fi

    # Validate worker node inputs
    if [[ "$SPARK_MODE" == "worker" ]]; then
        if [[ -z "$SPARK_MASTER_URL" ]]; then
            print_validation_error "For worker nodes you need to specify the SPARK_MASTER_URL"
        fi
    fi

    # Validate SSL parameters
    if is_boolean_yes "$SPARK_SSL_ENABLED"; then
        if [[ -z "$SPARK_SSL_KEY_PASSWORD" ]]; then
            print_validation_error "If you enable SSL configuration, you must provide the password to the private key in the key store."
        fi
        if [[ -z "$SPARK_SSL_KEYSTORE_PASSWORD" ]]; then
            print_validation_error "If you enable SSL configuration, you must provide the password to the key store."
        fi
        if [[ -z "$SPARK_SSL_TRUSTSTORE_PASSWORD" ]]; then
            print_validation_error "If you enable SSL configuration, you must provide the password to the trust store."
        fi
        if [[ ! -f "${SPARK_SSL_KEYSTORE_FILE}" ]]; then
            print_validation_error "If you enable SSL configuration, you must mount your keystore file and specify the location in SPARK_SSL_KEYSTORE_FILE. Default value: ${SPARK_SSL_KEYSTORE_FILE}"
        fi
        if [[ ! -f "${SPARK_SSL_TRUSTSTORE_FILE}" ]]; then
            print_validation_error "If you enable SSL configuration, you must mount your trutstore file and specify the location in SPARK_SSL_TRUSTSTORE_FILE. Default value: ${SPARK_SSL_TRUSTSTORE_FILE}\""
        fi
    fi

    # Validate RPC parameters
    if is_boolean_yes "$SPARK_RPC_AUTHENTICATION_ENABLED"; then
        if [[ -z "$SPARK_RPC_AUTHENTICATION_SECRET" ]]; then
            print_validation_error "If you enable RPC authentication, you must provide the RPC authentication secret."
        fi
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Configure Spark RPC Authentication (https://spark.apache.org/docs/latest/security.html#authentication)
# Globals:
#   SPARK_*
# Arguments:
#   None
# Returns:
#   None
#########################
spark_generate_conf_file() {
    info "Generating Spark configuration file..."
    mv "${SPARK_CONF_DIR}/spark-defaults.conf.template" "${SPARK_CONF_DIR}/spark-defaults.conf"
}

########################
# Configure Spark RPC Authentication (https://spark.apache.org/docs/latest/security.html#authentication)
# Globals:
#   SPARK_*
# Arguments:
#   None
# Returns:
#   None
#########################
spark_enable_rpc_authentication() {
    info "Configuring Spark RPC authentication..."

    echo "# Spark RPC Authentication settings" >>"${SPARK_CONF_DIR}/spark-defaults.conf"
    spark_conf_set spark.authenticate "true"
    spark_conf_set spark.authenticate.secret "$SPARK_RPC_AUTHENTICATION_SECRET"
}

########################
# Configure Spark RPC Encryption (https://spark.apache.org/docs/latest/security.html#encryption)
# Globals:
#   SPARK_*
# Arguments:
#   None
# Returns:
#   None
#########################
spark_enable_rpc_encryption() {
    info "Configuring Spark RPC encryption..."

    echo "# Spark RPC Encryption settings" >>"${SPARK_CONF_DIR}/spark-defaults.conf"
    spark_conf_set spark.network.crypto.enabled "true"
    spark_conf_set spark.network.crypto.keyLength "128"
}

########################
# Configure Spark Local Storage Encryption (https://spark.apache.org/docs/latest/security.html#local-storage-encryption)
# Globals:
#   SPARK_*
# Arguments:
#   None
# Returns:
#   None
#########################
spark_enable_local_storage_encryption() {
    info "Configuring Spark local storage encryption..."

    echo "# Spark Local Storate Encryption settings" >>"${SPARK_CONF_DIR}/spark-defaults.conf"
    spark_conf_set spark.io.encryption.enabled "true"
    spark_conf_set spark.io.encryption.keySizeBits "128"
}

########################
# Enable metrics
# Globals:
#   SPARK_*
# Arguments:
#   None
# Returns:
#   None
#########################
spark_enable_metrics() {
    info "Enabling metrics..."

    mv "${SPARK_CONF_DIR}/metrics.properties.template" "${SPARK_CONF_DIR}/metrics.properties"

    spark_metrics_conf_set "\*.sink.prometheusServlet.class" "org.apache.spark.metrics.sink.PrometheusServlet"
    spark_metrics_conf_set "\*.sink.prometheusServlet.path" "/metrics"
    spark_metrics_conf_set "master.sink.prometheusServlet.path" "/metrics"
    spark_metrics_conf_set "applications.sink.prometheusServlet.path" "/metrics"
}

########################
# Configure Spark SSL (https://spark.apache.org/docs/latest/security.html#ssl-configuration)
# Globals:
#   SPARK_*
# Arguments:
#   None
# Returns:
#   None
#########################
spark_enable_ssl() {
    info "Configuring Spark SSL..."

    echo "# Spark SSL settings" >>"${SPARK_CONF_DIR}/spark-defaults.conf"
    spark_conf_set spark.ssl.enabled "true"
    if ! is_empty_value "${SPARK_WEBUI_SSL_PORT}"; then
        spark_conf_set spark.ssl.standalone.port "${SPARK_WEBUI_SSL_PORT}"
    fi
    spark_conf_set spark.ssl.keyPassword "${SPARK_SSL_KEY_PASSWORD}"
    spark_conf_set spark.ssl.keyStore "${SPARK_SSL_KEYSTORE_FILE}"
    spark_conf_set spark.ssl.keyStorePassword "${SPARK_SSL_KEYSTORE_PASSWORD}"
    spark_conf_set spark.ssl.keyStoreType "JKS"
    spark_conf_set spark.ssl.protocol "${SPARK_SSL_PROTOCOL}"
    if is_boolean_yes "$SPARK_SSL_NEED_CLIENT_AUTH"; then
        spark_conf_set spark.ssl.needClientAuth "true"
    fi
    spark_conf_set spark.ssl.trustStore "${SPARK_SSL_TRUSTSTORE_FILE}"
    spark_conf_set spark.ssl.trustStorePassword "${SPARK_SSL_TRUSTSTORE_PASSWORD}"
    spark_conf_set spark.ssl.trustStoreType "JKS"
}

########################
# Set a metrics configuration setting value
# Globals:
#   SPARK_CONF_DIR
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
spark_metrics_conf_set() {
    local -r key="${1:?missing key}"
    local value="${2:-}"

    # Sanitize inputs
    value="${value//\\/\\\\}"
    value="${value//&/\\&}"
    value="${value//\?/\\?}"
    [[ "$value" = "" ]] && value="\"$value\""

    replace_in_file "${SPARK_CONF_DIR}/metrics.properties" "^#*\s*${key}.*" "${key}=${value}" false
}

########################
# Set a configuration setting value
# Globals:
#   SPARK_BASE_DIR
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
spark_conf_set() {
    # TODO: improve this. Substitute action?
    local key="${1:?missing key}"
    local value="${2:-}"

    # Sanitize inputs
    value="${value//\\/\\\\}"
    value="${value//&/\\&}"

    [[ "$value" = "" ]] && value="\"$value\""

    echo "$key $value" >>"${SPARK_BASE_DIR}/conf/spark-defaults.conf"
}

########################
# Ensure Spark is initialized
# Globals:
#   SPARK_*
# Arguments:
#   None
# Returns:
#   None
#########################
spark_initialize() {
    ensure_dir_exists "$SPARK_WORK_DIR"
    am_i_root && chown "$SPARK_DAEMON_USER:$SPARK_DAEMON_GROUP" "$SPARK_WORK_DIR"
    if [[ ! -f "$SPARK_CONF_FILE" ]]; then
        # Generate default config file
        spark_generate_conf_file
        # Enable RPC authentication and encryption
        if is_boolean_yes "$SPARK_RPC_AUTHENTICATION_ENABLED"; then
            spark_enable_rpc_authentication
            #  For encryption to be enabled, RPC authentication must also be enabled and properly configured
            if is_boolean_yes "$SPARK_RPC_ENCRYPTION_ENABLED"; then
                spark_enable_rpc_encryption
            fi
        fi

        # Enable RPC authentication and encryption
        if is_boolean_yes "$SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED"; then
            spark_enable_local_storage_encryption
        fi

        # Enable SSL configuration
        if is_boolean_yes "$SPARK_SSL_ENABLED"; then
            spark_enable_ssl
        fi

        # Enable metrics
        if is_boolean_yes "$SPARK_METRICS_ENABLED"; then
            spark_enable_metrics
        fi
    else
        info "Detected mounted configuration file..."
    fi
}

########################
# Run custom initialization scripts
# Globals:
#   SPARK_*
# Arguments:
#   None
# Returns:
#   None
#########################
spark_custom_init_scripts() {
    if [[ -n $(find "${SPARK_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh") ]]; then
        info "Loading user's custom files from $SPARK_INITSCRIPTS_DIR ..."
        local -r tmp_file="/tmp/filelist"
        find "${SPARK_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh" | sort >"$tmp_file"
        while read -r f; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    debug "Executing $f"
                    "$f"
                else
                    debug "Sourcing $f"
                    # shellcheck disable=SC1090
                    . "$f"
                fi
                ;;
            *)
                debug "Ignoring $f"
                ;;
            esac
        done <$tmp_file
        rm -f "$tmp_file"
    else
        info "No custom scripts in $SPARK_INITSCRIPTS_DIR"
    fi
}
