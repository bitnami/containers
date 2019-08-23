FROM bitnami/oraclelinux-extras-base:7-r387
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates jq
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.8.21-0" --checksum 13c329f8584ee901ebbece0d3f72325d22b4ac10a6b8a1c09aabdef3e33041e1
RUN . ./libcomponent.sh && component_unpack "minio" "2019.8.21-0" --checksum 88832066cd22993e1f3cada0627f54a8b1164c6d8174e6d91d54cc397813e86f

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2019.8.21-ol-7-r1" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
