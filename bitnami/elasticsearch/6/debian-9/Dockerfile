FROM bitnami/minideb-extras-base:stretch-r104
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libblkid1 libc6 libffi6 libgcc1 libglib2.0-0 libmount1 libpcre3 libselinux1 libuuid1 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "1.8.191-20" --checksum e193fab6c3c4de4d30f81a09d3b33978baa31761aaa330e39ce5ae8753db4133
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "6.5.3-0" --checksum da8e191635296244cbe47590d965e619b15e2c74f853d5d5b335127a61294dcb

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.5.3-debian-9-r4" \
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
