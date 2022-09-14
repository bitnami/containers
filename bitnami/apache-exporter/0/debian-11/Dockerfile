FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.11.0-debian-11-r40" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/apache-exporter" \
      org.opencontainers.image.title="apache-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.11.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f apache-exporter-0.11.0-154-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/apache-exporter-0.11.0-154-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/apache-exporter-0.11.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c apache-exporter-0.11.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf apache-exporter-0.11.0-154-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf apache-exporter-0.11.0-154-linux-${OS_ARCH}-debian-11.tar.gz apache-exporter-0.11.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /opt/bitnami/apache-exporter/bin/apache_exporter /bin/apache_exporter
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="0.11.0" \
    BITNAMI_APP_NAME="apache-exporter" \
    PATH="/opt/bitnami/apache-exporter/bin:$PATH"

EXPOSE 9117

WORKDIR /opt/bitnami/apache-exporter
USER 1001
ENTRYPOINT [ "apache_exporter" ]
