FROM bitnami/minideb-extras-base:stretch-r268
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.6.7-0" --checksum 7dc2a52b430b996d1a5bc0aac8cca3058128e22189cb3466fa6ab245a9b74938

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio-client" \
    BITNAMI_IMAGE_VERSION="2019.6.7-debian-9-r3" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:$PATH"

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
