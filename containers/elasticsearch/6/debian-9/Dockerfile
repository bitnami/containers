FROM bitnami/minideb-extras-base:stretch-r341
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "1.8.222-0" --checksum e5a677e160c01cd605bc6aae75cc937d4b2d37514b3e1d0a1dd2d332422e68c7
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "6.8.2-0" --checksum 6222ce47e77c22c9bb418c05f58bdaed65d1599036531233386a9b43abca5d37

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.8.2-debian-9-r26" \
    ELASTICSEARCH_BIND_ADDRESS="" \
    ELASTICSEARCH_CLUSTER_HOSTS="" \
    ELASTICSEARCH_CLUSTER_MASTER_HOSTS="" \
    ELASTICSEARCH_CLUSTER_NAME="elasticsearch-cluster" \
    ELASTICSEARCH_HEAP_SIZE="1024m" \
    ELASTICSEARCH_IS_DEDICATED_NODE="no" \
    ELASTICSEARCH_MINIMUM_MASTER_NODES="" \
    ELASTICSEARCH_NODE_NAME="" \
    ELASTICSEARCH_NODE_PORT_NUMBER="9300" \
    ELASTICSEARCH_NODE_TYPE="master" \
    ELASTICSEARCH_PLUGINS="" \
    ELASTICSEARCH_PORT_NUMBER="9200" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
