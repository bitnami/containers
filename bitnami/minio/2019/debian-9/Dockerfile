FROM bitnami/minideb-extras-base:stretch-r236
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates jq
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.5.1-0" --checksum 658534dc35d2678ddf5854ff68ee2a1a3a4e85f19ed96a7f4b10008464790011
RUN . ./libcomponent.sh && component_unpack "minio" "2019.5.2-0" --checksum af7b03575dbef712d408189920ac44e4b1753615557789eb453a22f00a5972a8

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2019.5.2-debian-9-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
