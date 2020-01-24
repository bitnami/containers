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
RUN . ./libcomponent.sh && component_unpack "minio-client" "2020.1.13-0" --checksum 726b010713951b007fcce98f02ea2b348160daed7c0a209428bf40f7e5e7efd3
RUN . ./libcomponent.sh && component_unpack "minio" "2020.1.16-0" --checksum e06771cce8f149a65906aa30a7673be300a3978ec95eec2a703435dad2b9d5d7
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2020.1.16-ol-7-r3" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
