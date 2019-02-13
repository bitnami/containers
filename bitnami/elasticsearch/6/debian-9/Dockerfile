FROM bitnami/minideb-extras-base:stretch-r160
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1
RUN . ./libcomponent.sh && component_unpack "java" "1.8.201-0" --checksum de49557872836fdbd965389ebcc72e163f7242cf691d435993cc2e4f3cd56ae7
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "6.6.0-0" --checksum 10d3179e968c0f27f416d96893b8c65b15a04919737fbf433332c07d09203bd1

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.6.0-debian-9-r8" \
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
