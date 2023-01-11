#!/bin/bash
#
# Bitnami Harbor library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh

########################
# Get the paths relevant to CA certs depending
# on the OS
# Globals:
#   OS_FLAVOUR
# Arguments:
#   None
# Returns:
#   A series of paths relevant to CA certs
#   depending on the OS.
#########################
get_system_cert_paths() {
    if [[ "$OS_FLAVOUR" =~ ^(debian|ubuntu)-.*$ ]]; then
        echo "/etc/ssl/certs/"
    elif [[ "$OS_FLAVOUR" =~ ^(centos|photon)-.*$ ]]; then
        echo "/etc/pki/tls/certs/"
    else
        # Check the existence of generic paths when OS_FLAVOR does
        # not match
        if [[ -d /etc/ssl/certs/ ]] ; then
            echo "/etc/ssl/certs/"
        elif [[ -d /etc/pki/tls/certs/ ]]; then
            echo "/etc/pki/tls/certs/"
        else
            error "Could not determine relevant CA paths for this OS Flavour"
        fi
    fi
}

########################
# Place a given certificate in the correct location for installation
# depending on the OS
# Globals:
#   OS_FLAVOUR*
# Arguments:
#   $1 - certificate to be installed
# Returns:
#   None
#########################
install_cert() {
    local -r cert="${1:?missing certificate}"

    if [[ "$OS_FLAVOUR" =~ ^(debian|ubuntu)-.*$ ]]; then
        cat "$cert" >> /etc/ssl/certs/ca-certificates.crt
    elif [[ "$OS_FLAVOUR" =~ ^(centos|photon)-.*$ ]]; then
        cat "$cert" >> /etc/pki/tls/certs/ca-bundle.crt
    else
        # Check the existence of generic ca-bundles when OS_FLAVOR does
        # not match
        if [[ -f /etc/ssl/certs/ca-certificates.crt ]] ; then
            cat "$cert" >> /etc/ssl/certs/ca-certificates.crt
        elif [[ -f /etc/pki/tls/certs/ca-bundle.crt ]]; then
            cat "$cert" >> /etc/pki/tls/certs/ca-bundle.crt
        else
            error "Could not install CA certificate ${cert} CA in this OS Flavour"
        fi
    fi
}

########################
# Install CA certificates found under the specific paths
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
install_custom_certs() {
    local installed=false

    # Install any internalTLS CA authority certificate, found under
    # /etc/harbor/ssl/{component}/ca.crt
    if [[ -d /etc/harbor/ssl ]]; then
        info "Appending internalTLS trust CA cert..."
        while IFS= read -r -d '' caCert; do
            install_cert "$caCert"
            installed=true
            debug "Internal tls trust CA $caCert copied"
        done < <(find /etc/harbor/ssl -maxdepth 2 -name ca.crt -print0)
        info "interalTLS CA certs appending done!"
    fi

    # Install any other custom certificate provided by the end user under the path
    # /harbor_cust_cert
    if [[ -d /harbor_cust_cert ]]; then
        info "Appending custom trust CA certs ..."
        for certFile in /harbor_cust_cert/*; do
            case ${certFile} in
                *.crt | *.ca | *.ca-bundle | *.pem)
                    if [[ -d "$certFile" ]]; then
                        debug "$certFile is a directory, skipping it"
                    else
                        install_cert "$certFile"
                        installed=true
                        debug "Custom CA cert $certFile copied"
                    fi
                    ;;
                *) debug "$certFile is not a CA cert file, skipping it" ;;
            esac
        done
    fi

    if [[ "$installed" = true ]]; then
        info "Custom certificates were installed in the system!"
    else
        info "No custom certificates were installed in the system"
    fi
}

########################
# Generate an .env file contents given an input string containing all envvars
# Arguments:
#   None
# Returns:
#   String
#########################
harbor_generate_env_file_contents() {
    local -r envvars_string="${1:?missing envvars}"
    echo "#!/bin/bash"
    while IFS= read -r ENV_VAR_LINE; do
        if [[ ! "$ENV_VAR_LINE" =~ ^[A-Z_] ]]; then
            continue
        fi
        ENV_VAR_NAME="${ENV_VAR_LINE/=*}"
        ENV_VAR_VALUE="${ENV_VAR_LINE#*=}"
        # Use single quotes to avoid shell expansion, and escape to be parsed properly (even if it contains quotes)
        # Escape the value, so it can be parsed as a variable even with quotes set
        echo "export ${ENV_VAR_NAME}='${ENV_VAR_VALUE//\'/\'\\\'\'}'"
    done <<< "$envvars_string"
}

########################
# Print harbor-core runtime environment
# Arguments:
#   None
# Returns:
#   Boolean
#########################
harbor_core_print_env() {
    # The CSRF key can only be up to 32 characters long
    HARBOR_CORE_CFG_CSRF_KEY="${HARBOR_CORE_CFG_CSRF_KEY:0:32}"
    for var in "${!HARBOR_CORE_CFG_@}"; do
        echo "${var/HARBOR_CORE_CFG_/}=${!var}"
    done
}

########################
# Check if harbor-core is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_core_running() {
    # harbor-core does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "$(command -v harbor_core)" > "$HARBOR_CORE_PID_FILE"

    pid="$(get_pid_from_file "$HARBOR_CORE_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if harbor-core is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_core_not_running() {
    ! is_harbor_core_running
}

########################
# Stop harbor-core
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_core_stop() {
    ! is_harbor_core_running && return
    stop_service_using_pid "$HARBOR_CORE_PID_FILE"
}

########################
# Print harbor-jobservice runtime environment
# Arguments:
#   None
# Returns:
#   Boolean
#########################
harbor_jobservice_print_env() {
    for var in "${!HARBOR_JOBSERVICE_CFG_@}"; do
        echo "${var/HARBOR_JOBSERVICE_CFG_/}=${!var}"
    done
}

########################
# Check if harbor-jobservice is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_jobservice_running() {
    # harbor-jobservice does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "$(command -v harbor_jobservice)" > "$HARBOR_JOBSERVICE_PID_FILE"

    pid="$(get_pid_from_file "$HARBOR_JOBSERVICE_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if harbor-jobservice is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_jobservice_not_running() {
    ! is_harbor_jobservice_running
}

########################
# Stop harbor-jobservice
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_jobservice_stop() {
    ! is_harbor_jobservice_running && return
    stop_service_using_pid "$HARBOR_JOBSERVICE_PID_FILE"
}

########################
# Print harbor-notary-server runtime environment
# Arguments:
#   None
# Returns:
#   Boolean
#########################
harbor_notary_server_print_env() {
    if [[ -n "${HARBOR_NOTARY_SERVER_DATABASE_NAME:-}" ]]; then
        # shellcheck disable=SC2034
        HARBOR_NOTARY_SERVER_CFG_DB_URL="postgres://${HARBOR_NOTARY_SERVER_DATABASE_USERNAME:-}:${HARBOR_NOTARY_SERVER_DATABASE_PASSWORD:-}@${HARBOR_NOTARY_SERVER_DATABASE_HOST:-127.0.0.1}:${HARBOR_NOTARY_SERVER_DATABASE_PORT_NUMBER:-5432}/${HARBOR_NOTARY_SERVER_DATABASE_NAME}?sslmode=${HARBOR_NOTARY_SERVER_DATABASE_SSLMODE:-disable}"
    fi
    for var in "${!HARBOR_NOTARY_SERVER_CFG_@}"; do
        echo "${var/HARBOR_NOTARY_SERVER_CFG_/}=${!var}"
    done
}

########################
# Check if harbor-notary-server is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_notary_server_running() {
    # harbor-notary-server does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "$(command -v notary-server)" > "$HARBOR_NOTARY_SERVER_PID_FILE"

    pid="$(get_pid_from_file "$HARBOR_NOTARY_SERVER_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if harbor-notary-server is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_notary_server_not_running() {
    ! is_harbor_notary_server_running
}

########################
# Stop harbor-notary-server
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_notary_server_stop() {
    ! is_harbor_notary_server_running && return
    stop_service_using_pid "$HARBOR_NOTARY_SERVER_PID_FILE"
}

########################
# Print harbor-notary-signer runtime environment
# Arguments:
#   None
# Returns:
#   Boolean
#########################
harbor_notary_signer_print_env() {
    if [[ -n "${HARBOR_NOTARY_SIGNER_DATABASE_NAME:-}" ]]; then
        # shellcheck disable=SC2034
        HARBOR_NOTARY_SIGNER_CFG_DB_URL="postgres://${HARBOR_NOTARY_SIGNER_DATABASE_USERNAME:-}:${HARBOR_NOTARY_SIGNER_DATABASE_PASSWORD:-}@${HARBOR_NOTARY_SIGNER_DATABASE_HOST:-127.0.0.1}:${HARBOR_NOTARY_SIGNER_DATABASE_PORT_NUMBER:-5432}/${HARBOR_NOTARY_SIGNER_DATABASE_NAME}?sslmode=${HARBOR_NOTARY_SIGNER_DATABASE_SSLMODE:-disable}"
    fi
    for var in "${!HARBOR_NOTARY_SIGNER_CFG_@}"; do
        echo "${var/HARBOR_NOTARY_SIGNER_CFG_/}=${!var}"
    done
}

########################
# Check if harbor-notary-signer is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_notary_signer_running() {
    # harbor-notary-signer does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "$(command -v notary-signer)" > "$HARBOR_NOTARY_SIGNER_PID_FILE"

    pid="$(get_pid_from_file "$HARBOR_NOTARY_SIGNER_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if harbor-notary-signer is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_notary_signer_not_running() {
    ! is_harbor_notary_signer_running
}

########################
# Stop harbor-notary-signer
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_notary_signer_stop() {
    ! is_harbor_notary_signer_running && return
    stop_service_using_pid "$HARBOR_NOTARY_SIGNER_PID_FILE"
}

########################
# Print harbor-registry runtime environment
# Arguments:
#   None
# Returns:
#   Boolean
#########################
harbor_registry_print_env() {
    if [[ -n "$HARBOR_REGISTRY_USER" && -n "$HARBOR_REGISTRY_PASSWORD" ]]; then
        HARBOR_REGISTRY_CFG_REGISTRY_HTPASSWD="$(htpasswd -nbBC10 "$HARBOR_REGISTRY_USER" "$HARBOR_REGISTRY_PASSWORD")"
        # Update passwd file
        echo "$HARBOR_REGISTRY_CFG_REGISTRY_HTPASSWD" >/etc/registry/passwd
    fi
    for var in "${!HARBOR_REGISTRY_CFG_@}"; do
        echo "${var/HARBOR_REGISTRY_CFG_/}=${!var}"
    done
}

########################
# Check if harbor-registry is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_registry_running() {
    # harbor-registry does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "$(command -v registry)" > "$HARBOR_REGISTRY_PID_FILE"

    pid="$(get_pid_from_file "$HARBOR_REGISTRY_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if harbor-registry is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_registry_not_running() {
    ! is_harbor_registry_running
}

########################
# Stop harbor-registry
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_registry_stop() {
    ! is_harbor_registry_running && return
    stop_service_using_pid "$HARBOR_REGISTRY_PID_FILE"
}

########################
# Print harbor-registryctl runtime environment
# Arguments:
#   None
# Returns:
#   Boolean
#########################
harbor_registryctl_print_env() {
    if [[ -n "$HARBOR_REGISTRYCTL_USER" && -n "$HARBOR_REGISTRYCTL_PASSWORD" ]]; then
        HARBOR_REGISTRYCTL_CFG_REGISTRY_HTPASSWD="$(htpasswd -nbBC10 "$HARBOR_REGISTRYCTL_USER" "$HARBOR_REGISTRYCTL_PASSWORD")"
        # Update passwd file
        echo "$HARBOR_REGISTRYCTL_CFG_REGISTRY_HTPASSWD" >/etc/registry/passwd
    fi
    for var in "${!HARBOR_REGISTRYCTL_CFG_@}"; do
        echo "${var/HARBOR_REGISTRYCTL_CFG_/}=${!var}"
    done
}

########################
# Check if harbor-registryctl is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_registryctl_running() {
    # harbor-registryctl does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "$(command -v harbor_registryctl)" > "$HARBOR_REGISTRYCTL_PID_FILE"

    pid="$(get_pid_from_file "$HARBOR_REGISTRYCTL_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if harbor-registryctl is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_registryctl_not_running() {
    ! is_harbor_registryctl_running
}

########################
# Stop harbor-registryctl
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_registryctl_stop() {
    ! is_harbor_registryctl_running && return
    stop_service_using_pid "$HARBOR_REGISTRYCTL_PID_FILE"
    # The service may not respond properly to the default kill signal, so send a SIGKILL if it fails
    local -r retries=5
    local -r sleep_time=1
    if ! retry_while "is_harbor_registryctl_not_running" "$retries" "$sleep_time"; then
        stop_service_using_pid "$HARBOR_REGISTRYCTL_PID_FILE" SIGKILL
    fi
}

########################
# Print harbor-adapter-trivy runtime environment
# Arguments:
#   None
# Returns:
#   Boolean
#########################
harbor_adapter_trivy_print_env() {
    for var in "${!SCANNER_TRIVY_CFG_@}"; do
        echo "${var/SCANNER_TRIVY_CFG_/}=${!var}"
    done
}

########################
# Check if harbor-adapter-trivy is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_adapter_trivy_running() {
    # harbor-adapter-trivy does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "$(command -v scanner-trivy)" > "$SCANNER_TRIVY_PID_FILE"

    pid="$(get_pid_from_file "$SCANNER_TRIVY_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if harbor-adapter-trivy is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_adapter_trivy_not_running() {
    ! is_harbor_adapter_trivy_running
}

########################
# Stop harbor-adapter-trivy
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_adapter_trivy_stop() {
    ! is_harbor_adapter_trivy_running && return
    stop_service_using_pid "$SCANNER_TRIVY_PID_FILE"
}

########################
# Print chartmuseum runtime environment
# Arguments:
#   None
# Returns:
#   Boolean
#########################
chartmuseum_print_env() {
    for var in "${!CHARTMUSEUM_CFG_@}"; do
        echo "${var/CHARTMUSEUM_CFG_/}=${!var}"
    done
}

########################
# Check if chartmuseum is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_chartmuseum_running() {
    # chartmuseum does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "$(command -v chartmuseum)" > "$CHARTMUSEUM_PID_FILE"

    pid="$(get_pid_from_file "$CHARTMUSEUM_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if chartmuseum is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_chartmuseum_not_running() {
    ! is_chartmuseum_running
}

########################
# Stop chartmuseum
# Arguments:
#   None
# Returns:
#   None
#########################
chartmuseum_stop() {
    ! is_chartmuseum_running && return
    stop_service_using_pid "$CHARTMUSEUM_PID_FILE"
}
