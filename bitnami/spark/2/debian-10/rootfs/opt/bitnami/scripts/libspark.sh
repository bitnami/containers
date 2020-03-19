#!/bin/bash
#
# Bitnami Spark library

# shellcheck disable=SC1091

# Load Libraries
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

########################
# Load global variables used on Spark configuration
# Globals:
#  SPARK_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
spark_env() {
    cat <<"EOF"
# Spark directories
export SPARK_BASEDIR="/opt/bitnami/spark"
export SPARK_CONFDIR="${SPARK_BASEDIR}/conf"
export SPARK_WORKDIR="${SPARK_BASEDIR}/work"
export SPARK_CONF_FILE="${SPARK_CONFDIR}/spark-defaults.conf"
export SPARK_LOGDIR="${SPARK_BASEDIR}/logs"
export SPARK_TMPDIR="${SPARK_BASEDIR}/tmp"

# Spark basic cluster
export SPARK_MODE="${SPARK_MODE:-master}"
export SPARK_MASTER_URL="${SPARK_MASTER_URL:-spark://spark-master:7077}"
export SPARK_NO_DAEMONIZE="${SPARK_NO_DAEMONIZE:-true}"

# RPC Authentication and Encryption
export SPARK_RPC_AUTHENTICATION_ENABLED="${SPARK_RPC_AUTHENTICATION_ENABLED:-no}"
export SPARK_RPC_AUTHENTICATION_SECRET="${SPARK_RPC_AUTHENTICATION_SECRET:-}"
export SPARK_RPC_ENCRYPTION_ENABLED="${SPARK_RPC_ENCRYPTION_ENABLED:-no}"

# Local Storage Encryption
export SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED="${SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED:-no}"

# SSL
export SPARK_SSL_ENABLED="${SPARK_SSL_ENABLED:-no}"
export SPARK_SSL_KEY_PASSWORD="${SPARK_SSL_KEY_PASSWORD:-}"
export SPARK_SSL_KEYSTORE_PASSWORD="${SPARK_SSL_KEYSTORE_PASSWORD:-}"
export SPARK_SSL_TRUSTSTORE_PASSWORD="${SPARK_SSL_TRUSTSTORE_PASSWORD:-}"
export SPARK_SSL_NEED_CLIENT_AUTH="${SPARK_SSL_NEED_CLIENT_AUTH:-yes}"
export SPARK_SSL_PROTOCOL="${SPARK_SSL_PROTOCOL:-TLSv1.2}"

# System Users
export SPARK_DAEMON_USER="spark"
export SPARK_DAEMON_GROUP="spark"
EOF
}

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
        master|worker)
        ;;
        *)
            print_validation_error "Invalid mode $SPARK_MODE. Supported types are 'master/worker'"
    esac

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
        if [[ ! -f "${SPARK_CONFDIR}/certs/spark-keystore.jks" ]]; then
            print_validation_error "If you enable SSL configuration, you must mount your keystore file to \"${SPARK_CONFDIR}/certs/spark-keystore.jks\""
        fi
        if [[ ! -f "${SPARK_CONFDIR}/certs/spark-truststore.jks" ]]; then
            print_validation_error "If you enable SSL configuration, you must mount your trutstore file to \"${SPARK_CONFDIR}/certs/spark-truststore.jks\""
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
    mv "${SPARK_CONFDIR}/spark-defaults.conf.template" "${SPARK_CONFDIR}/spark-defaults.conf"
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

    echo "# Spark RPC Authentication settings" >> "${SPARK_CONFDIR}/spark-defaults.conf"
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

    echo "# Spark RPC Encryption settings" >> "${SPARK_CONFDIR}/spark-defaults.conf"
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

    echo "# Spark Local Storate Encryption settings" >> "${SPARK_CONFDIR}/spark-defaults.conf"
    spark_conf_set spark.io.encryption.enabled "true"
    spark_conf_set spark.io.encryption.keySizeBits "128"
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

    echo "# Spark SSL settings" >> "${SPARK_CONFDIR}/spark-defaults.conf"
    spark_conf_set spark.ssl.enabled "true"
    spark_conf_set spark.ssl.keyPassword "${SPARK_SSL_KEY_PASSWORD}"
    spark_conf_set spark.ssl.keyStore "${SPARK_CONFDIR}/certs/spark-keystore.jks"
    spark_conf_set spark.ssl.keyStorePassword "${SPARK_SSL_KEYSTORE_PASSWORD}"
    spark_conf_set spark.ssl.keyStoreType "JKS"
    spark_conf_set spark.ssl.protocol "${SPARK_SSL_PROTOCOL}"
    if is_boolean_yes "$SPARK_SSL_NEED_CLIENT_AUTH"; then
        spark_conf_set spark.ssl.needClientAuth "true"
    fi
    spark_conf_set spark.ssl.trustStore "${SPARK_CONFDIR}/certs/spark-truststore.jks"
    spark_conf_set spark.ssl.trustStorePassword "${SPARK_SSL_TRUSTSTORE_PASSWORD}"
    spark_conf_set spark.ssl.trustStoreType "JKS"
}
########################
# Set a configuration setting value
# Globals:
#   SPARK_BASEDIR
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

    echo "$key $value" >> "${SPARK_BASEDIR}/conf/spark-defaults.conf"
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
    ensure_dir_exists "$SPARK_WORKDIR"
    am_i_root && chown "$SPARK_DAEMON_USER:$SPARK_DAEMON_GROUP" "$SPARK_WORKDIR"

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
    else
        info "Detected mounted configuration file..."
    fi
}
