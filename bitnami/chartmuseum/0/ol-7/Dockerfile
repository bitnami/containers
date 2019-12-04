FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip hostname libaio-devel procps-ng sudo tar which
RUN . ./libcomponent.sh && component_unpack "chartmuseum" "0.10.0-0" --checksum d0ff38f9f6f96d18d302b5524370c93bb58578432aee9f5e8b2d1590e893bc4e

COPY rootfs /
ENV BITNAMI_APP_NAME="chartmuseum" \
    BITNAMI_IMAGE_VERSION="0.10.0-ol-7-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/chartmuseum/bin:$PATH"

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
