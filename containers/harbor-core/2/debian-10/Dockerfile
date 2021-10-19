FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.0-3" --checksum 7521d9a4f9e4e182bf32977e234026caa7b03759799868335bccb1edd8f8fd12
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.0-0" --checksum 88093e848950fd09e80eb26cac55caa11e77aa78f118b5dc67faa38a3836381d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-core" "2.3.3-1" --checksum 553c19bdbf0d57c0e119e57c5e8d7287c6aab8d549a0e2438d414f59c23ca39d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-core/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-core" \
    BITNAMI_IMAGE_VERSION="2.3.3-debian-10-r21" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/harbor-core/bin:$PATH"

VOLUME [ "/data", "/etc/core" ]

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-core
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-core/entrypoint.sh" ]
CMD [ "harbor_core" ]
