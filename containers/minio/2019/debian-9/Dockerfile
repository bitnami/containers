FROM bitnami/minideb-extras-base:stretch-r231
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates jq
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.4.24-0" --checksum a7d714fbbe5438f38877d1da86b3ebf054dee5df8949630f8b29124141e6abb3
RUN . ./libcomponent.sh && component_unpack "minio" "2019.4.23-0" --checksum c5245b93c504afa174baf7b96553444bb5c56f1b1ed5d719c23d6629a51967ed

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2019.4.23-debian-9-r3" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
