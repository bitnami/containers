FROM bitnami/oraclelinux-extras:7-r61
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glib2 glibc libblkid libffi libgcc libmount libselinux libstdc++ libuuid pcre zlib
RUN bitnami-pkg install java-1.8.181-1 --checksum 6e7fc2779b6e0e3c6c0a2687b1d747d8a427594ff80b8c94b055c839e387e6b1
RUN bitnami-pkg unpack elasticsearch-5.6.4-5 --checksum 7dbde2b964ead379a1ca756c4f207d93055ba321be40de5358dfd1aa3ef04203
RUN mkdir -p /bitnami/elasticsearch/conf/ && chmod g+rwX /bitnami/elasticsearch/conf/

COPY rootfs /
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="5.6.4-ol-7-r31" \
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
