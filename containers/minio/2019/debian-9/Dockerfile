FROM bitnami/minideb-extras-base:stretch-r351
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates jq
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.8.29-0" --checksum 4b5ddeadb39dea6f5a8043d0f92cec0a0b22573a38664b07a5d8fdc7c33b5a00
RUN . ./libcomponent.sh && component_unpack "minio" "2019.8.29-0" --checksum a14552fb043278ac012e8b6aa878a60e33e502307f7350e81d027600e6a8ee53

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2019.8.29-debian-9-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
