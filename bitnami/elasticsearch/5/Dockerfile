FROM bitnami/minideb-extras:jessie-r17
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libexpat1 libffi6 libfontconfig1 libfreetype6 libgcc1 libglib2.0-0 liblzma5 libpcre3 libpng12-0 libselinux1 libstdc++6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 zlib1g
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27
RUN bitnami-pkg unpack elasticsearch-5.4.2-0 --checksum 24411db6a5211b8c8a06a81a8d08a293bd390e412a9e49d2630fdaf61c3da4cb

COPY rootfs /

ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="5.4.2-r0" \
    ELASTICSEARCH_CLIENT_NODE="" \
    ELASTICSEARCH_CLUSTER_HOSTS="" \
    ELASTICSEARCH_CLUSTER_NAME="elasticsearch-cluster" \
    ELASTICSEARCH_NODE_NAME="" \
    ELASTICSEARCH_NODE_PORT_NUMBER="9300" \
    ELASTICSEARCH_PORT_NUMBER="9200" \
    ELASTICSEARCH_REMOTE_CONNECTION="true" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"



VOLUME ["/bitnami/elasticsearch"]

EXPOSE 9200 9300

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","elasticsearch"]
