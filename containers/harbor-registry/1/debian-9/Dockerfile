FROM bitnami/minideb-extras-base:stretch-r376
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.9.1-0" --checksum a2cee0260bb8b316f2032d1d9b05a9ca52408b6dc1258c570615abcce79c5d08

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registry" \
    BITNAMI_IMAGE_VERSION="1.9.1-debian-9-r5" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/storage", "/var/lib/registry" ]

EXPOSE 5000

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
