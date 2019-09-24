FROM bitnami/minideb-extras-base:stretch-r368
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "harbor-core" "1.9.0-1" --checksum d16095c01f2b325ead66dbcfac0d309e4f891c64377fde0b0541d37bffa539d5

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-core" \
    BITNAMI_IMAGE_VERSION="1.9.0-debian-9-r6" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-core/bin:$PATH"

VOLUME [ "/etc/core", "/data" ]

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-core
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "harbor_core" ]
