FROM bitnami/oraclelinux-extras-base:7-r423
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates jq
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.9.20-0" --checksum bd34438a49c726afb878c95dbeb9daa93b2330b3e11c5a59d2691dde213340a6
RUN . ./libcomponent.sh && component_unpack "minio" "2019.9.18-0" --checksum 82fb874ed06389c56f8922bc660bd96e3a9ffb9c7131ee57b6969f7d6b8b36be

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2019.9.18-ol-7-r2" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
