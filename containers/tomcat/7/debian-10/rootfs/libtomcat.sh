#!/bin/bash
#
# Bitnami Tomcat library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /libfile.sh
. /liblog.sh
. /libos.sh
. /libservice.sh
. /libvalidations.sh

########################
# Loads global variables used on Tomcat configuration.
# Globals:
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
tomcat_env() {
    cat <<"EOF"
# Bitnami debug
export MODULE=tomcat
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

## Paths
export TOMCAT_BASE_DIR="/opt/bitnami/tomcat"
export TOMCAT_CONF_DIR="${TOMCAT_BASE_DIR}/conf"
export TOMCAT_BIN_DIR="${TOMCAT_BASE_DIR}/bin"
export TOMCAT_TMP_DIR="${TOMCAT_BASE_DIR}/tmp"
export TOMCAT_LOG_DIR="${TOMCAT_BASE_DIR}/logs"
export TOMCAT_LIB_DIR="${TOMCAT_BASE_DIR}/lib"
export TOMCAT_WORK_DIR="${TOMCAT_BASE_DIR}/work"
export TOMCAT_WEBAPPS_DIR="/bitnami/tomcat/data"
export TOMCAT_JAVA_ROOT_DIR="/opt/bitnami/java"
export TOMCAT_CONF_FILE="${TOMCAT_CONF_DIR}/server.xml"
export TOMCAT_USERS_CONF_FILE="${TOMCAT_CONF_DIR}/tomcat-users.xml"
export TOMCAT_LOG_FILE="${TOMCAT_LOG_DIR}/catalina.out"

## Users
export TOMCAT_DAEMON_USER="tomcat"
export TOMCAT_DAEMON_GROUP="tomcat"

## JVM
export JAVA_HOME="${JAVA_HOME:-$TOMCAT_JAVA_ROOT_DIR}"
export JAVA_OPTS="${JAVA_OPTS:--Djava.awt.headless=true -XX:+UseG1GC -Dfile.encoding=UTF-8}"

## Exposed
export TOMCAT_SHUTDOWN_PORT_NUMBER="${TOMCAT_SHUTDOWN_PORT_NUMBER:-8005}"
export TOMCAT_HTTP_PORT_NUMBER="${TOMCAT_HTTP_PORT_NUMBER:-8080}"
export TOMCAT_AJP_PORT_NUMBER="${TOMCAT_AJP_PORT_NUMBER:-8009}"
export TOMCAT_HOME="${TOMCAT_HOME:-$TOMCAT_BASE_DIR}"
export TOMCAT_USERNAME="${TOMCAT_USERNAME:-user}"
export TOMCAT_PASSWORD="${TOMCAT_PASSWORD:-}"
export TOMCAT_ALLOW_REMOTE_MANAGEMENT="${TOMCAT_ALLOW_REMOTE_MANAGEMENT:-0}"
EOF
}

########################
# Validate settings in MYSQL_*/MARIADB_* environment variables
# Globals:
#   DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
tomcat_validate() {
    debug "Validating settings in TOMCAT_* env vars..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_conflicting_ports() {
        local -r total="$#"

        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                if (( "${!i}" == "${!j}" )); then
                    print_validation_error "${!i} and ${!j} are bound to the same port"
                fi
            done
        done
    }

    check_allowed_port() {
        local validate_port_args="-unprivileged"

        if ! err=$(validate_port "${validate_port_args[@]}" "${!1}"); then
            print_validation_error "An invalid port was specified in the environment variable $1: $err"
        fi
    }

    check_allowed_port TOMCAT_HTTP_PORT_NUMBER
    check_allowed_port TOMCAT_AJP_PORT_NUMBER
    check_allowed_port TOMCAT_SHUTDOWN_PORT_NUMBER

    check_conflicting_ports TOMCAT_HTTP_PORT_NUMBER TOMCAT_AJP_PORT_NUMBER TOMCAT_SHUTDOWN_PORT_NUMBER

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Configure ports
# Globals:
#   TOMCAT_
# Arguments:
#   None
# Returns:
#   None
#########################
tomcat_configure_ports() {
    replace_in_file "$TOMCAT_CONF_FILE" "port=\"8080\"" "port=\"$TOMCAT_HTTP_PORT_NUMBER\""
    replace_in_file "$TOMCAT_CONF_FILE" "port=\"8005\"" "port=\"$TOMCAT_SHUTDOWN_PORT_NUMBER\""
    replace_in_file "$TOMCAT_CONF_FILE" "port=\"8009\"" "port=\"$TOMCAT_AJP_PORT_NUMBER\""
}

########################
# Apply regex in configuration file
# Globals:
#   JAVA_HOME, TOMCAT_*
# Arguments:
#   None
# Returns:
#   None
#########################
tomcat_setup_environment() {
    cat > "${TOMCAT_BIN_DIR}/setenv.sh" <<EOF
#!/bin/bash
JAVA_HOME="$JAVA_HOME"
export JAVA_HOME

JAVA_OPTS="$JAVA_OPTS"
export JAVA_OPTS

# Load Tomcat Native library
LD_LIBRARY_PATH="${TOMCAT_LIB_DIR}:\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH
EOF
}

########################
# Overwrite context of a Tomcat application
# Globals:
#   TOMCAT_*
# Arguments:
#   $1 - application
#   $2 - context
# Returns:
#   None
#########################
tomcat_overwrite_context() {
    local -r application=${1:?application is missing}
    local -r context=${2:?context is missing}
    local -r file="${TOMCAT_WEBAPPS_DIR}/${application}/META-INF/context.xml"
    local file_content

    file_content="$(sed '/<Context/,/<\/Context>/c'"$context" "$file")"
    echo "$file_content" > "$file"
}

########################
# Render tag from a value and attributes
# Globals:
#   None
# Arguments:
#   $1 - name
#   $2 - attribute
#   $3 - child
# Returns:
#   Rendered tag string
########################
tomcat_render_tag() {
    local -r name=${1:?name is missing}
    local -r attributes=${2:?attributes is missing}
    local -r child=${3:-}

    local rendered

    if [[ -z "$child" ]]; then
        rendered="<$name $attributes/>"
    else
        rendered="<$name $attributes>\n $child\n</$name>"
    fi

    echo "$rendered"
}

########################
# Enable manager and host-manager to accept remote connections
# Globals:
#   TOMCAT_*
# Arguments:
#   None
# Returns:
#   None
#########################
tomcat_enable_remote_management() {
    local inner_tag
    info "Enabling remote connections for manager and host-manager applications..."

    inner_tag=$(tomcat_render_tag Valve "className=\"org.apache.catalina.valves.RemoteAddrValve\" allow=\"\\\d+\\\.\\\d+\\\.\\\d+\\\.\\\d+\"")

    tomcat_overwrite_context manager "$(tomcat_render_tag Context "antiResourceLocking=\"false\" privileged=\"true\"" "$inner_tag")"
    tomcat_overwrite_context host-manager "$(tomcat_render_tag Context "antiResourceLocking=\"false\" privileged=\"true\"" "$inner_tag")"
}

########################
# Create tomcat user
# Globals:
#   TOMCAT_*
# Arguments:
#   $1 - name
#   $2 - password
# Returns:
#   None
#########################
tomcat_create_tomcat_user() {
    local username=${1:?username is missing}
    local password=${2:-}

    local user_definition="<user username=\"${username}\" password=\"${password}\" roles=\"manager-gui,admin-gui\"/></tomcat-users>"

    replace_in_file "$TOMCAT_USERS_CONF_FILE" "</tomcat-users>" "$user_definition"
}

########################
# Ensure Tomcat is initialized
# Globals:
#   TOMCAT_*
# Arguments:
#   None
# Returns:
#   None
#########################
tomcat_initialize() {
    info "Initializing Tomcat server..."

    am_i_root && chown -LR "$TOMCAT_DAEMON_USER":"$TOMCAT_DAEMON_GROUP" "$TOMCAT_TMP_DIR" "$TOMCAT_LOG_DIR" "$TOMCAT_WORK_DIR" "$TOMCAT_CONF_DIR" "$TOMCAT_BIN_DIR" "$TOMCAT_LIB_DIR"
    ensure_dir_exists "$TOMCAT_WEBAPPS_DIR"
    am_i_root && configure_permissions_ownership "$TOMCAT_WEBAPPS_DIR" -u "$TOMCAT_DAEMON_USER" -g "$TOMCAT_DAEMON_GROUP" -d "755" -f "644"
    am_i_root && configure_permissions_ownership "${TOMCAT_BASE_DIR}/webapps_default" -u "$TOMCAT_DAEMON_USER" -g "$TOMCAT_DAEMON_GROUP" -d "755" -f "644"

    if is_dir_empty "$TOMCAT_WEBAPPS_DIR"; then
        info "Deploying Tomcat from scratch..."

        cp -r "$TOMCAT_BASE_DIR"/webapps_default/* "$TOMCAT_WEBAPPS_DIR"
    else
        info "Persisted webapps detected."
    fi

    tomcat_configure_ports
    tomcat_setup_environment
    tomcat_create_tomcat_user "$TOMCAT_USERNAME" "$TOMCAT_PASSWORD"

    if is_boolean_yes "$TOMCAT_ALLOW_REMOTE_MANAGEMENT"; then
        tomcat_enable_remote_management
    fi
}
