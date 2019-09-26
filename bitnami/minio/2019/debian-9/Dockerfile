FROM bitnami/minideb-extras-base:stretch-r369
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates jq
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.9.24-0" --checksum 360ef2673cd36f629826b335c303077a3a1d7081a2376f2e155ce8f91edc8c46
RUN . ./libcomponent.sh && component_unpack "minio" "2019.9.25-0" --checksum f6afc687245dd3bc0ed02172140ef1a84abaa4a36b01014138ec95eb2cfb60a9

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2019.9.25-debian-9-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
