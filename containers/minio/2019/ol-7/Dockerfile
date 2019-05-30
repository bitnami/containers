FROM bitnami/oraclelinux-extras-base:7-r298
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates jq
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.5.29-0" --checksum a06681f8b5a749a8c29f8fcd1fb319743b7440d3f5a6637f478bfe1ab5c6a26b
RUN . ./libcomponent.sh && component_unpack "minio" "2019.5.23-1" --checksum 3ae5c543e80222d18bfc1d9a2346d6d13c134149a515c9f5d47bbebcf8f26f35

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2019.5.23-ol-7-r3" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
