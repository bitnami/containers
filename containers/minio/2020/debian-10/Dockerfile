FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl jq procps sudo unzip
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "minio-client" "2020.5.5-0" --checksum d2b19060d881419ff483f7e5103fcb218dc9520df956cdfc6ea9791b6468b0a3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "minio" "2020.5.1-0" --checksum 698a17ac56b7788d0ddf3cafb744ecea6edb9bb99f5382ed75a9e9c8fbc5ba6a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/minio/postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2020.5.1-debian-10-r4" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:/opt/bitnami/common/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/minio/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/minio/run.sh" ]
