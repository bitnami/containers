FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.22.0-debian-11-r8" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/blackbox-exporter" \
      org.opencontainers.image.title="blackbox-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.22.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f blackbox-exporter-0.22.0-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/blackbox-exporter-0.22.0-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "f9481a7c5116a8c8ff0e5f295f0d367b4db78f8086161c34720e9432b758fcf2  blackbox-exporter-0.22.0-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf blackbox-exporter-0.22.0-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf blackbox-exporter-0.22.0-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="0.22.0" \
    BITNAMI_APP_NAME="blackbox-exporter" \
    PATH="/opt/bitnami/blackbox-exporter/bin:$PATH"

EXPOSE 9115

WORKDIR /opt/bitnami/blackbox-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/blackbox-exporter/bin/blackbox_exporter" ]
