FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2022.8.28-debian-11-r3" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/minio-client" \
      org.opencontainers.image.title="minio-client" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2022.8.28"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f minio-client-2022.8.28-0-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/minio-client-2022.8.28-0-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/minio-client-2022.8.28-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c minio-client-2022.8.28-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf minio-client-2022.8.28-0-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf minio-client-2022.8.28-0-linux-${OS_ARCH}-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz
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
