FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.6.5-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/haproxy" \
      org.opencontainers.image.title="haproxy" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.6.5"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libssl1.1 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f haproxy-dataplaneapi-2.6.0-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/haproxy-dataplaneapi-2.6.0-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "22519edc1bfeef288ad7665f2b9ff6dc9c2a9820f53ebf800aea2aa64e8f58f4  haproxy-dataplaneapi-2.6.0-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf haproxy-dataplaneapi-2.6.0-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf haproxy-dataplaneapi-2.6.0-2-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f haproxy-2.6.5-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/haproxy-2.6.5-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "ca52f990cda30b0c6a80ba9b4320b08b6cba48ba6a34ca49d2ba4419ddf640d8  haproxy-2.6.5-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf haproxy-2.6.5-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf haproxy-2.6.5-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="2.6.5" \
    BITNAMI_APP_NAME="haproxy" \
    PATH="/opt/bitnami/haproxy-dataplaneapi/bin:/opt/bitnami/haproxy/sbin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/haproxy/sbin/haproxy" ]
CMD [ "-f", "/bitnami/haproxy/conf/haproxy.cfg" ]
