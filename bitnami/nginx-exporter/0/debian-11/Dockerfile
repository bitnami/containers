FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.10.0-debian-11-r29" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/nginx-exporter" \
      org.opencontainers.image.title="nginx-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.10.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nginx-exporter-0.10.0-152-linux-amd64-debian-11.tar.gz && \
    echo "5271e5dadbfae75a07cc4c7beeb6f72ffaa7bb6dfe6066741bd9c4d6951d5859  /tmp/bitnami/pkg/cache/nginx-exporter-0.10.0-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nginx-exporter-0.10.0-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nginx-exporter-0.10.0-152-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/nginx-exporter/bin/nginx-prometheus-exporter /usr/bin/exporter

ENV APP_VERSION="0.10.0" \
    BITNAMI_APP_NAME="nginx-exporter" \
    PATH="/opt/bitnami/nginx-exporter/bin:$PATH"

EXPOSE 9113

WORKDIR /opt/bitnami/nginx-exporter
USER 1001
ENTRYPOINT [ "nginx-prometheus-exporter" ]
