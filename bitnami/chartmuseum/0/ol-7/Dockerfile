FROM bitnami/oraclelinux-extras-base:7-r420
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN . ./libcomponent.sh && component_unpack "chartmuseum" "0.9.0-1" --checksum a962d91c0568bdc383a3d6fcae6278de7e3c1303666c02fcc6a89a9ff35d235c

COPY rootfs /
ENV BITNAMI_APP_NAME="chartmuseum" \
    BITNAMI_IMAGE_VERSION="0.9.0-ol-7-r43" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/chartmuseum/bin:$PATH"

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
