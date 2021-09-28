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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-core" "2.3.3-0" --checksum e8f3b0a137d16c4a712669287a99a589807b2e3a271bc2606fc61f2cb770a202
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-core/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-core" \
    BITNAMI_IMAGE_VERSION="2.3.3-debian-10-r0" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/harbor-core/bin:$PATH"

VOLUME [ "/data", "/etc/core" ]

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-core
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-core/entrypoint.sh" ]
CMD [ "harbor_core" ]
