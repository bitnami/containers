FROM bitnami/oraclelinux-extras-base:7-r381
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.8.14-0" --checksum 5a3ce963732955a515d31bf894b31cf158f25958331528c958912eadcff98c7f

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio-client" \
    BITNAMI_IMAGE_VERSION="2019.8.14-ol-7-r3" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:$PATH"

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
