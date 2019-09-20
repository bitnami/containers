FROM bitnami/oraclelinux-extras-base:7-r423
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.9.20-0" --checksum bd34438a49c726afb878c95dbeb9daa93b2330b3e11c5a59d2691dde213340a6

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio-client" \
    BITNAMI_IMAGE_VERSION="2019.9.20-ol-7-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:$PATH"

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
