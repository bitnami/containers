#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

export WP_CLI_CONFIG_PATH="{{WP_CLI_CONF_FILE}}"
export WP_CLI_CACHE_DIR="{{WP_CLI_BASE_DIR}}/.cache"
export WP_CLI_PACKAGES_DIR="{{WP_CLI_BASE_DIR}}/.packages"
export WP_CLI_PHP_USED="{{PHP_BIN_DIR}}/php"

command -v less > /dev/null || export PAGER=cat

exec {{PHP_BIN_DIR}}/php {{WP_CLI_BIN_DIR}}/wp-cli.phar "$@"
