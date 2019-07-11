FROM bitnami/oraclelinux-extras-base:7-r344
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc
RUN . ./libcomponent.sh && component_unpack "harbor-core" "1.8.1-0" --checksum 81a9bc25a7649e90e1ecd245092f3cffea4ca765db36a5881cfa2b3d2dd8dad2

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-core" \
    BITNAMI_IMAGE_VERSION="1.8.1-ol-7-r9" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-core/bin:$PATH"

VOLUME [ "/etc/core", "/data" ]

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-core
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "harbor_core" ]
