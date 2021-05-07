#!/bin/bash

export WP_CLI_CONFIG_PATH="{{WORDPRESS_CLI_CONF_FILE}}"
export WP_CLI_CACHE_DIR="{{WORDPRESS_CLI_BASE_DIR}}/.cache"
export WP_CLI_PACKAGES_DIR="{{WORDPRESS_CLI_BASE_DIR}}/.packages"
export WP_CLI_PHP_USED="{{PHP_BIN_DIR}}/php"

command -v less > /dev/null || export PAGER=cat

exec {{PHP_BIN_DIR}}/php {{WORDPRESS_CLI_BIN_DIR}}/wp-cli.phar "$@"
