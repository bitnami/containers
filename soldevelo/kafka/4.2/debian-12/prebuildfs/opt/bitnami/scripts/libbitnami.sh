#!/bin/bash
# Copyright 2026 SolDevelo
# Based on Bitnami Kafka © Broadcom, Inc. (Apache-2.0)
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami custom library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh

# Constants
BOLD='\033[1m'

# Functions

########################
# Print the welcome page
# Globals:
#   DISABLE_WELCOME_MESSAGE
#   BITNAMI_APP_NAME
# Arguments:
#   None
# Returns:
#   None
#########################
print_welcome_page() {
    if [[ -z "${DISABLE_WELCOME_MESSAGE:-}" ]]; then
        if [[ -n "$BITNAMI_APP_NAME" ]]; then
            print_image_welcome_page
        fi
    fi
}

########################
# Print the welcome page for a Bitnami Docker image
# Globals:
#   BITNAMI_APP_NAME
# Arguments:
#   None
# Returns:
#   None
#########################
print_image_welcome_page() {
    local github_url="https://github.com/bitnami/containers"

    info ""
    info "${BOLD}Welcome to the SolDevelo ${BITNAMI_APP_NAME} container${RESET}"
    info ""
}

