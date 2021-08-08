FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 lsof netcat-traditional procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.302-0" --checksum 59c0b7440797c7110c76959dbbce5235359b52adf62f99218b2718c04f2d67b6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "solr" "8.9.0-0" --checksum cc4fd7f80cfc163fa7aecf7df384fbf6e913290ceb6a2f94ff464530b7073403
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/solr/postunpack.sh
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="8.9.0-debian-10-r41" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/solr/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/solr/run.sh" ]
