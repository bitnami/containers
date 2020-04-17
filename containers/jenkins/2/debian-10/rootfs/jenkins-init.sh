#!/bin/bash

# Auxiliar Functions

########################
# Check if the script is currently running as root
# Arguments: none
# Returns:
#   Boolean
#########################
am_i_root() {
    if [[ "$(id -u)" = "0" ]]; then
        true
    else
        false
    fi
}
########################
# Check if an user exists in the system
# Arguments:
#   $1 - uid
# Returns:
#   Boolean
#########################
user_exists() {
    local uid="${1:?uid is missing}"
    getent passwd "$uid" >/dev/null 2>&1
}

if ! am_i_root && ! user_exists "$(id -u)" && [[ -e "/opt/bitnami/common/lib/libnss_wrapper.so" ]]; then
    echo "jenkins:x:$(id -u):$(id -g):Jenkins:$JENKINS_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "jenkins:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
else
    unset LD_PRELOAD
fi
