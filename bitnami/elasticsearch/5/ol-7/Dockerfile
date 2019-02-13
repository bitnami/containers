FROM bitnami/oraclelinux-extras-base:7-r206
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc hostname libgcc
RUN . ./libcomponent.sh && component_unpack "java" "1.8.201-0" --checksum e71b797ceaaf8b0641d1641df129cea10124b058bc24d4ed74738725fabfb8c9
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "5.6.14-2" --checksum 579c4cdb40d3c525e5086b18538cbd7d37186ea101ff0c4c3e7240a9f42d7ba1

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="5.6.14-ol-7-r51" \
    ELASTICSEARCH_BIND_ADDRESS="" \
    ELASTICSEARCH_CLUSTER_HOSTS="" \
    ELASTICSEARCH_CLUSTER_NAME="elasticsearch-cluster" \
    ELASTICSEARCH_HEAP_SIZE="1024m" \
    ELASTICSEARCH_IS_DEDICATED_NODE="no" \
    ELASTICSEARCH_MINIMUM_MASTER_NODES="" \
    ELASTICSEARCH_NODE_NAME="" \
    ELASTICSEARCH_NODE_PORT_NUMBER="9300" \
    ELASTICSEARCH_NODE_TYPE="master" \
    ELASTICSEARCH_PLUGINS="" \
    ELASTICSEARCH_PORT_NUMBER="9200" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
