FROM bitnami/minideb-extras-base:stretch-r372
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates jq
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.9.24-0" --checksum 360ef2673cd36f629826b335c303077a3a1d7081a2376f2e155ce8f91edc8c46
RUN . ./libcomponent.sh && component_unpack "minio" "2019.9.26-0" --checksum 5136272da1dff1d497c0e906b9bf8f5e571aac16e6a4d5507cf57ace1eb01830

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2019.9.26-debian-9-r2" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
