FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.11.1-debian-11-r4" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/postgres-exporter" \
      org.opencontainers.image.title="postgres-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.11.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f postgres-exporter-0.11.1-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/postgres-exporter-0.11.1-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "68c1ea1394bfa0adf10308c2512df826b345eece1213e11264e66f2d4de695f5  postgres-exporter-0.11.1-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf postgres-exporter-0.11.1-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf postgres-exporter-0.11.1-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="0.11.1" \
    BITNAMI_APP_NAME="postgres-exporter" \
    PATH="/opt/bitnami/postgres-exporter/bin:$PATH"

EXPOSE 9187

WORKDIR /opt/bitnami/postgres-exporter
USER 1001
ENTRYPOINT [ "postgres_exporter" ]
