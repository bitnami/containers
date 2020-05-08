#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libelasticsearch.sh
. /opt/bitnami/scripts/libfs.sh

# Load Elasticsearch environment variables
eval "$(elasticsearch_env)"

for dir in "$ELASTICSEARCH_TMP_DIR" "$ELASTICSEARCH_DATA_DIR" "$ELASTICSEARCH_LOG_DIR" "${ELASTICSEARCH_BASE_DIR}/plugins" "${ELASTICSEARCH_BASE_DIR}/modules" "$ELASTICSEARCH_CONF_DIR" "$ELASTICSEARCH_VOLUME_DIR" "$ELASTICSEARCH_INITSCRIPTS_DIR" "$ELASTICSEARCH_MOUNTED_PLUGINS_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R ug+rwX "$dir"
    # `elasticsearch-plugin install` command complains about being unable to create the a plugin's directory
    # even when having the proper permissions.
    # The reason: the code is checking trying to check the permissions by consulting the parent directory owner,
    # instead of checking if the ES user actually has writing permissions.
    #
    # As a workaround, we will ensure the container works (at least) with the non-root user 1001. However,
    # until we can avoid this hack, we can't guarantee this container to work on K8s distributions
    # where containers are exectued with non-privileged users with random user IDs.
    #
    # Issue reported at: https://github.com/bitnami/bitnami-docker-elasticsearch/issues/50
    chown -R 1001:0 "$dir"
done
