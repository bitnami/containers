FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg install java-1.8.144-1 --checksum 2f8fdda7d9a8d8ad57efc76fe2b1a322a9ec30395b6bcb09464901256348066c
RUN bitnami-pkg unpack elasticsearch-5.6.2-0 --checksum 01348783849d9b05de46ebb9b7a888d5e1ee482d6f03c3d580ba66b95ca395d7

COPY rootfs /

ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="5.6.2-r0" \
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
