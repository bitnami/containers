#!/bin/bash
#
# Bitnami Harbor library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh

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
