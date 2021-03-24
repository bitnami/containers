FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 lsof netcat-traditional procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.282-0" --checksum 473d0ab64adfe82d84dd810c28e0f22242eeffbaf74a85febf7586ce013aa7ba
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "solr" "8.8.1-0" --checksum 08b0f5986ad59036d44cc0919c0324ba9c51127cf2c5d971ab170c33969fb41e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/solr/postunpack.sh
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="8.8.1-debian-10-r27" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:/opt/bitnami/common/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="_default" \
    SOLR_HEAP="512m" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/solr/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/solr/run.sh" ]
