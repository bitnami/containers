FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.34.0-debian-11-r8" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/mongodb-exporter" \
      org.opencontainers.image.title="mongodb-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.34.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f mongodb-exporter-0.34.0-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/mongodb-exporter-0.34.0-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "549cdc461d4e70642c679c00b892e55897eba01181b629934e94c41f7a0e9a67  mongodb-exporter-0.34.0-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf mongodb-exporter-0.34.0-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf mongodb-exporter-0.34.0-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/mongodb-exporter/bin/mongodb_exporter /bin/mongodb_exporter

ENV APP_VERSION="0.34.0" \
    BITNAMI_APP_NAME="mongodb-exporter" \
    PATH="/opt/bitnami/mongodb-exporter/bin:$PATH"

EXPOSE 9216

WORKDIR /opt/bitnami/mongodb-exporter
USER 1001
ENTRYPOINT [ "mongodb_exporter" ]
