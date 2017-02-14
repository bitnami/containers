FROM gcr.io/stacksmith-images/minideb:jessie-r9

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=elasticsearch \
    BITNAMI_IMAGE_VERSION=2.4.4-r0 \
    PATH=/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH

# System packages required
RUN install_packages libc6 libxext6 libx11-6 libxcb1 libxau6 libxdmcp6 libglib2.0-0 libfreetype6 libfontconfig1 libstdc++6 libgcc1 zlib1g libselinux1 libpng12-0 libexpat1 libffi6 libpcre3 libxml2 liblzma5

# Additional modules required
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27

# Install elasticsearch
RUN bitnami-pkg unpack elasticsearch-2.4.4-0 --checksum 3c05a4da328a904cf3a694e3a4e4636538754d97472bdbe5a15c56b69861965c

COPY rootfs /

ENV ELASTICSEARCH_PORT="9200" \
    ELASTICSEARCH_NODE_PORT="9300" \
    ELASTICSEARCH_CLUSTER_NAME="elasticsearch-cluster"

VOLUME ["/bitnami/elasticsearch"]

EXPOSE 9200 9300

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "elasticsearch"]
