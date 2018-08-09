FROM bitnami/minideb-extras:stretch-r101
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libblkid1 libbsd0 libc6 libffi6 libgcc1 libglib2.0-0 libmount1 libpcre3 libselinux1 libstdc++6 libuuid1 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 zlib1g
RUN bitnami-pkg install java-1.8.181-1 --checksum 66bba4b4a2647f981339d306da796905c222057c4277a5ef045e079981a404f4
RUN bitnami-pkg unpack elasticsearch-6.3.2-2 --checksum 4ab7d9a87236ff776a66e2fbda3b789bfcbd371dc859479e786404e637170be3
RUN mkdir -p /bitnami/elasticsearch/conf/ && chmod g+rwX /bitnami/elasticsearch/conf/

COPY rootfs /
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.3.2-debian-9-r15" \
    ELASTICSEARCH_BIND_ADDRESS="" \
    ELASTICSEARCH_CLUSTER_HOSTS="" \
    ELASTICSEARCH_CLUSTER_NAME="elasticsearch-cluster" \
    ELASTICSEARCH_HEAP_SIZE="1024m" \
    ELASTICSEARCH_IS_DEDICATED_NODE="no" \
    ELASTICSEARCH_NODE_NAME="" \
    ELASTICSEARCH_NODE_PORT_NUMBER="9300" \
    ELASTICSEARCH_NODE_TYPE="master" \
    ELASTICSEARCH_PLUGINS="" \
    ELASTICSEARCH_PORT_NUMBER="9200" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","elasticsearch"]
