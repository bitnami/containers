FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2022.8.28-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/minio-client" \
      org.opencontainers.image.title="minio-client" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2022.8.28"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "minio-client" "2022.8.28-0" --checksum ec03cdf0a6bdcd9d6a8bad989f09b0818edec9a23f60616beaddc06e2328a44f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/minio-client/postunpack.sh
ENV APP_VERSION="2022.8.28" \
    BITNAMI_APP_NAME="minio-client" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/minio-client/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/minio-client/run.sh" ]
