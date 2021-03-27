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

if ! am_i_root && ! user_exists "$(id -u)" && [[ -f "$LD_PRELOAD" ]]; then
    echo "INFO  ==> Configuring libnss_wrapper..."
    NSS_WRAPPER_PASSWD="$(mktemp)"
    export NSS_WRAPPER_PASSWD
    NSS_WRAPPER_GROUP="$(mktemp)"
    export NSS_WRAPPER_GROUP
    echo "jenkins:x:$(id -u):$(id -g):Jenkins:$JENKINS_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "jenkins:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
    chmod 400 "$NSS_WRAPPER_PASSWD" "$NSS_WRAPPER_GROUP"
fi
