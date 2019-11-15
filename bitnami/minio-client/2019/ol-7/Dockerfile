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
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.10.9-0" --checksum 5d5f1311a28427cc9419387b407aa1482b78f76e9288fc48de63ae292fdac3b8

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio-client" \
    BITNAMI_IMAGE_VERSION="2019.10.9-ol-7-r40" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:$PATH"

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
