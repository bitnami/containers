FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip hostname jq libaio-devel procps-ng sudo tar which
RUN . ./libcomponent.sh && component_unpack "minio-client" "2020.2.20-0" --checksum 20d0e35f9874ef480a9d36fa39d13cf17b067576d58fc994b9eaa4a9aac33f8c
RUN . ./libcomponent.sh && component_unpack "minio" "2020.2.20-0" --checksum a43097b958d1a18d4a9b4d20755ad50a85f13eed50ea2c69b4867969914b26b2
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2020.2.20-ol-7-r2" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
