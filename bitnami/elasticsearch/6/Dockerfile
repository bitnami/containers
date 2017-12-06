FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg install java-1.8.151-0 --checksum fbbea572d89988035aee16eefe53c852e8abfda84f6c7cf5c9a4772a72863143
RUN bitnami-pkg unpack elasticsearch-6.0.1-0 --checksum ecd4628f75681959bd97bdbfb3298eec4a7967f60cf312ff30777f3bc2b7bf8b

COPY rootfs /

ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.0.1-r0" \
    ELASTICSEARCH_CLIENT_NODE="" \
    ELASTICSEARCH_CLUSTER_HOSTS="" \
    ELASTICSEARCH_CLUSTER_NAME="elasticsearch-cluster" \
    ELASTICSEARCH_HEAP_SIZE="" \
    ELASTICSEARCH_NODE_NAME="" \
    ELASTICSEARCH_NODE_PORT_NUMBER="9300" \
    ELASTICSEARCH_PLUGINS="" \
    ELASTICSEARCH_PORT_NUMBER="9200" \
    ELASTICSEARCH_REMOTE_CONNECTION="true" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","elasticsearch"]
