#!/bin/bash
#
# Bitnami OpenLDAP library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Load global variables used on OpenLDAP configuration
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
ldap_env() {
    cat << "EOF"
# Paths
export LDAP_BASE_DIR="/opt/bitnami/openldap"
export LDAP_BIN_DIR="${LDAP_BASE_DIR}/bin"
export LDAP_SBIN_DIR="${LDAP_BASE_DIR}/sbin"
export LDAP_CONF_DIR="${LDAP_BASE_DIR}/etc"
export LDAP_SHARE_DIR="${LDAP_BASE_DIR}/share"
export LDAP_VOLUME_DIR="/bitnami/openldap"
export LDAP_DATA_DIR="${LDAP_VOLUME_DIR}/data"
export LDAP_ONLINE_CONF_DIR="${LDAP_VOLUME_DIR}/slapd.d"
export LDAP_PID_FILE="${LDAP_BASE_DIR}/var/run/slapd.pid"
export LDAP_CUSTOM_LDIF_DIR="${LDAP_CUSTOM_LDIF_DIR:-/ldifs}"
export LDAP_CUSTOM_SCHEMA_FILE="${LDAP_CUSTOM_SCHEMA_FILE:-/schema/custom.ldif}"
export PATH="${LDAP_BIN_DIR}:${LDAP_SBIN_DIR}:$PATH"
export LDAP_TLS_CERT_FILE="${LDAP_TLS_CERT_FILE:-}"
export LDAP_TLS_KEY_FILE="${LDAP_TLS_KEY_FILE:-}"
export LDAP_TLS_CA_FILE="${LDAP_TLS_CA_FILE:-}"
export LDAP_TLS_DH_PARAMS_FILE="${LDAP_TLS_DH_PARAMS_FILE:-}"
# Users
export LDAP_DAEMON_USER="slapd"
export LDAP_DAEMON_GROUP="slapd"
# Settings
export LDAP_PORT_NUMBER="${LDAP_PORT_NUMBER:-1389}"
export LDAP_LDAPS_PORT_NUMBER="${LDAP_LDAPS_PORT_NUMBER:-1636}"
export LDAP_ROOT="${LDAP_ROOT:-dc=example,dc=org}"
export LDAP_ADMIN_USERNAME="${LDAP_ADMIN_USERNAME:-admin}"
export LDAP_ADMIN_DN="${LDAP_ADMIN_USERNAME/#/cn=},${LDAP_ROOT}"
export LDAP_ADMIN_PASSWORD="${LDAP_ADMIN_PASSWORD:-adminpassword}"
export LDAP_ENCRYPTED_ADMIN_PASSWORD="$(echo -n $LDAP_ADMIN_PASSWORD | slappasswd -n -T /dev/stdin)"
export LDAP_EXTRA_SCHEMAS="${LDAP_EXTRA_SCHEMAS:-cosine,inetorgperson,nis}"
export LDAP_SKIP_DEFAULT_TREE="${LDAP_SKIP_DEFAULT_TREE:-no}"
export LDAP_USERS="${LDAP_USERS:-user01,user02}"
export LDAP_PASSWORDS="${LDAP_PASSWORDS:-bitnami1,bitnami2}"
export LDAP_USER_DC="${LDAP_USER_DC:-users}"
export LDAP_GROUP="${LDAP_GROUP:-readers}"
export LDAP_ENABLE_TLS="${LDAP_ENABLE_TLS:-no}"
export LDAP_ULIMIT_NOFILES="${LDAP_ULIMIT_NOFILES:-1024}"
EOF
}

########################
# Validate settings in LDAP_* environment variables
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_validate() {
    info "Validating settings in LDAP_* env vars"
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_allowed_port() {
        local port_var="${1:?missing port variable}"
        local validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        if ! err=$(validate_port "${validate_port_args[@]}" "${!port_var}"); then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }
    for var in LDAP_SKIP_DEFAULT_TREE LDAP_ENABLE_TLS; do
        if ! is_yes_no_value "${!var}"; then
            print_validation_error "The allowed values for $var are: yes or no"
        fi
    done

    if is_boolean_yes "$LDAP_ENABLE_TLS"; then
        if [[ -z "$LDAP_TLS_CERT_FILE" ]]; then
            print_validation_error "You must provide a X.509 certificate in order to use TLS"
        elif [[ ! -f "$LDAP_TLS_CERT_FILE" ]]; then
            print_validation_error "The X.509 certificate file in the specified path ${LDAP_TLS_CERT_FILE} does not exist"
        fi
        if [[ -z "$LDAP_TLS_KEY_FILE" ]]; then
            print_validation_error "You must provide a private key in order to use TLS"
        elif [[ ! -f "$LDAP_TLS_KEY_FILE" ]]; then
            print_validation_error "The private key file in the specified path ${LDAP_TLS_KEY_FILE} does not exist"
        fi
        if [[ -z "$LDAP_TLS_CA_FILE" ]]; then
            print_validation_error "You must provide a CA X.509 certificate in order to use TLS"
        elif [[ ! -f "$LDAP_TLS_CA_FILE" ]]; then
            print_validation_error "The CA X.509 certificate file in the specified path ${LDAP_TLS_CA_FILE} does not exist"
        fi
    fi

    read -r -a users <<< "$(tr ',;' ' ' <<< "${LDAP_USERS}")"
    read -r -a passwords <<< "$(tr ',;' ' ' <<< "${LDAP_PASSWORDS}")"
    if [[ "${#users[@]}" -ne "${#passwords[@]}" ]]; then
        print_validation_error "Specify the same number of passwords on LDAP_PASSWORDS as the number of users on LDAP_USERS!"
    fi

    if [[ -n "$LDAP_PORT_NUMBER" ]] && [[ -n "$LDAP_LDAPS_PORT_NUMBER" ]]; then
        if [[ "$LDAP_PORT_NUMBER" -eq "$LDAP_LDAPS_PORT_NUMBER" ]]; then
            print_validation_error "LDAP_PORT_NUMBER and LDAP_LDAPS_PORT_NUMBER are bound to the same port!"
        fi
    fi
    [[ -n "$LDAP_PORT_NUMBER" ]] && check_allowed_port LDAP_PORT_NUMBER
    [[ -n "$LDAP_LDAPS_PORT_NUMBER" ]] && check_allowed_port LDAP_LDAPS_PORT_NUMBER

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Check if OpenLDAP is running
# Globals:
#   LDAP_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether slapd is running
#########################
is_ldap_running() {
    local pid
    pid="$(get_pid_from_file "${LDAP_PID_FILE}")"
    if [[ -n "${pid}" ]]; then
        is_service_running "${pid}"
    else
        false
    fi
}

########################
# Check if OpenLDAP is not running
# Arguments:
#   None
# Returns:
#   Whether slapd is not running
#########################
is_ldap_not_running() {
    ! is_ldap_running
}

########################
# Start OpenLDAP server in background
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_start_bg() {
    local -a flags=("-h" "ldap://:${LDAP_PORT_NUMBER}/ ldapi:/// " "-F" "${LDAP_CONF_DIR}/slapd.d")
    if is_ldap_not_running; then
        info "Starting OpenLDAP server in background"
        ulimit -n "$LDAP_ULIMIT_NOFILES"
        am_i_root && flags=("-u" "$LDAP_DAEMON_USER" "${flags[@]}")
        debug_execute slapd "${flags[@]}"
    fi
}

########################
# Stop OpenLDAP server
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_stop() {
    local -r retries=25
    local -r sleep_time=1

    are_db_files_locked() {
        local return_value=0
        read -r -a db_files <<< "$(find "$LDAP_DATA_DIR" -type f | xargs)"
        for f in "${db_files[@]}"; do
            debug_execute lsof -w "$f" && return_value=1
        done
        return $return_value
    }

    if ! is_ldap_running ; then 
        return
    fi

    stop_service_using_pid "$LDAP_PID_FILE"
    if ! retry_while are_db_files_locked "$retries" "$sleep_time"; then
        error "OpenLDAP failed to stop"
        return 1
    fi
}

########################
# Create LDAP online configuration
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_create_online_configuration() {
    info "Creating LDAP online configuration"

    ! am_i_root && replace_in_file "${LDAP_SHARE_DIR}/slapd.ldif" "uidNumber=0" "uidNumber=$(id -u)"
    debug_execute slapadd -F "$LDAP_ONLINE_CONF_DIR" -n 0 -l "${LDAP_SHARE_DIR}/slapd.ldif"
}

########################
# Configure LDAP credentials for admin user
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_admin_credentials() {
    info "Configure LDAP credentials for admin user"
    cat > "${LDAP_SHARE_DIR}/admin.ldif" << EOF
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: $LDAP_ROOT

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: $LDAP_ADMIN_DN

dn: olcDatabase={2}hdb,cn=config
changeType: modify
add: olcRootPW
olcRootPW: $LDAP_ENCRYPTED_ADMIN_PASSWORD

dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external, cn=auth" read by dn.base="${LDAP_ADMIN_DN}" read by * none
EOF
    debug_execute ldapmodify -Y EXTERNAL -H "ldapi:///" -f "${LDAP_SHARE_DIR}/admin.ldif"
}

########################
# Add LDAP schemas
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns
#   None
#########################
ldap_add_schemas() {
    info "Adding LDAP extra schemas"
    read -r -a schemas <<< "$(tr ',;' ' ' <<< "${LDAP_EXTRA_SCHEMAS}")"
    for schema in "${schemas[@]}"; do
        debug_execute ldapadd -Y EXTERNAL -H "ldapi:///" -f "${LDAP_CONF_DIR}/schema/${schema}.ldif"
    done
}

########################
# Add custom schema
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns
#   None
#########################
ldap_add_custom_schema() {
    info "Adding custom Schema : $LDAP_CUSTOM_SCHEMA_FILE ..."
    debug_execute slapadd -F "$LDAP_ONLINE_CONF_DIR" -n 0 -l  "$LDAP_CUSTOM_SCHEMA_FILE"
    ldap_stop
     while is_ldap_running; do sleep 1; done
    ldap_start_bg
}

########################
# Create LDAP tree
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_create_tree() {
    info "Creating LDAP default tree"
    local dc=""
    local o="example"
    read -r -a root <<< "$(tr ',;' ' ' <<< "${LDAP_ROOT}")"
    for attr in "${root[@]}"; do
        if [[ $attr = dc=* ]] && [[ -z "$dc" ]]; then
            dc="${attr:3}"
        elif [[ $attr = o=* ]] && [[ $o = "example" ]]; then
            o="${attr:2}"
        fi
    done
    cat > "${LDAP_SHARE_DIR}/tree.ldif" << EOF
# Root creation
dn: $LDAP_ROOT
objectClass: dcObject
objectClass: organization
dc: $dc
o: $o

dn: ${LDAP_USER_DC/#/ou=},${LDAP_ROOT}
objectClass: organizationalUnit
ou: users

EOF
    read -r -a users <<< "$(tr ',;' ' ' <<< "${LDAP_USERS}")"
    read -r -a passwords <<< "$(tr ',;' ' ' <<< "${LDAP_PASSWORDS}")"
    local index=0
    for user in "${users[@]}"; do
        cat >> "${LDAP_SHARE_DIR}/tree.ldif" << EOF
# User $user creation
dn: ${user/#/cn=},${LDAP_USER_DC/#/ou=},${LDAP_ROOT}
cn: User$((index + 1 ))
sn: Bar$((index + 1 ))
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
userPassword: ${passwords[$index]}
uid: $user
uidNumber: $((index + 1000 ))
gidNumber: $((index + 1000 ))
homeDirectory: /home/${user}

EOF
        index=$((index + 1 ))
    done
    cat >> "${LDAP_SHARE_DIR}/tree.ldif" << EOF
# Group creation
dn: ${LDAP_GROUP/#/cn=},${LDAP_USER_DC/#/ou=},${LDAP_ROOT}
cn: $LDAP_GROUP
objectClass: groupOfNames
# User group membership
EOF

    for user in "${users[@]}"; do
        cat >> "${LDAP_SHARE_DIR}/tree.ldif" << EOF
member: ${user/#/cn=},${LDAP_USER_DC/#/ou=},${LDAP_ROOT}
EOF
    done

    debug_execute ldapadd -f "${LDAP_SHARE_DIR}/tree.ldif" -H "ldapi:///" -D "$LDAP_ADMIN_DN" -w "$LDAP_ADMIN_PASSWORD"
}

########################
# Add custom LDIF files
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns
#   None
#########################
ldap_add_custom_ldifs() {
    info "Loading custom LDIF files..."
    warn "Ignoring LDAP_USERS, LDAP_PASSWORDS, LDAP_USER_DC and LDAP_GROUP environment variables..."
    find "$LDAP_CUSTOM_LDIF_DIR" -maxdepth 1 \( -type f -o -type l \) -iname '*.ldif' -print0 | sort -z | xargs --null -I{} bash -c ". /opt/bitnami/scripts/libos.sh && debug_execute ldapadd -f {} -H 'ldapi:///' -D $LDAP_ADMIN_DN -w $LDAP_ADMIN_PASSWORD"
}

########################
# OpenLDAP configure permissions
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_configure_permissions() {
  debug "Ensuring expected directories/files exist..."
  for dir in "$LDAP_SHARE_DIR" "$LDAP_DATA_DIR" "$LDAP_ONLINE_CONF_DIR"; do
      ensure_dir_exists "$dir"
      if am_i_root; then
          chown -R "$LDAP_DAEMON_USER:$LDAP_DAEMON_GROUP" "$dir"
      fi
  done
}

########################
# Initialize OpenLDAP server
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_initialize() {
    info "Initializing OpenLDAP..."

    ldap_configure_permissions
    if ! is_dir_empty "$LDAP_DATA_DIR"; then
        info "Using persisted data"
    else
        # Create OpenLDAP online configuration
        ldap_create_online_configuration
        ldap_start_bg
        ldap_admin_credentials
        if is_boolean_yes "$LDAP_ENABLE_TLS"; then
            ldap_configure_tls
        fi
        if is_boolean_yes "$LDAP_SKIP_DEFAULT_TREE"; then
            info "Skipping default schemas/tree structure"
        else
            # Initialize OpenLDAP with schemas/tree structure
            ldap_add_schemas
            if [[ -f "$LDAP_CUSTOM_SCHEMA_FILE" ]]; then
                ldap_add_custom_schema
            fi
            if ! is_dir_empty "$LDAP_CUSTOM_LDIF_DIR"; then
                ldap_add_custom_ldifs
            else
                ldap_create_tree
            fi
        fi
        ldap_stop
    fi
}

########################
# OpenLDAP configure TLS
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_configure_tls() {
    info "Configuring TLS"
    cat > "${LDAP_SHARE_DIR}/certs.ldif" << EOF
dn: cn=config
changetype: modify
replace: olcTLSCACertificateFile
olcTLSCACertificateFile: $LDAP_TLS_CA_FILE
-
replace: olcTLSCertificateFile
olcTLSCertificateFile: $LDAP_TLS_CERT_FILE
-
replace: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: $LDAP_TLS_KEY_FILE
EOF
    if [[ -f "$LDAP_TLS_DH_PARAMS_FILE" ]]; then
        cat >> "${LDAP_SHARE_DIR}/certs.ldif" << EOF
-
replace: olcTLSDHParamFile
olcTLSDHParamFile: $LDAP_TLS_DH_PARAMS_FILE
EOF
    fi
    debug_execute ldapmodify -Y EXTERNAL -H "ldapi:///" -f "${LDAP_SHARE_DIR}/certs.ldif"
}
