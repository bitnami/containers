#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnginxldapauthdaemon.sh

# Load NGINX environment variables
eval "$(nginxldap_env)"

flags=("--host" "${NGINXLDAP_HOSTNAME}" "-p" "${NGINXLDAP_PORT_NUMBER}" "--url" "${NGINXLDAP_LDAP_URI}")
[[ -n "${NGINXLDAP_LDAP_BASE_DN}" ]] && flags=("${flags[@]}" "-b" "${NGINXLDAP_LDAP_BASE_DN}")
[[ -n "${NGINXLDAP_LDAP_BIND_DN}" ]] && flags=("${flags[@]}" "-D ${NGINXLDAP_LDAP_BIND_DN}")
[[ -n "${NGINXLDAP_LDAP_BIND_PASSWORD}" ]] && flags=("${flags[@]}" "-w ${NGINXLDAP_LDAP_BIND_PASSWORD}")
[[ -n "${NGINXLDAP_LDAP_FILTER}" ]] && flags=("${flags[@]}" "-f ${NGINXLDAP_LDAP_FILTER}")
[[ -n "${NGINXLDAP_HTTP_REALM}" ]] && flags=("${flags[@]}" "-R ${NGINXLDAP_HTTP_REALM}")
[[ -n "${NGINXLDAP_HTTP_COOKIE_NAME}" ]] && flags=("${flags[@]}" "-c ${NGINXLDAP_HTTP_COOKIE_NAME}")

info "** Starting NGINX LDAP Auth daemong **"
# shellcheck source=/dev/null
. "${NGINXLDAP_PYTHON_BIN_DIR}"/activate
exec python "${NGINXLDAP_SCRIPT_FILE}" "${flags[@]}"
