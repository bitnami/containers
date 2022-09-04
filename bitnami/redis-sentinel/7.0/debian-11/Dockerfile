FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/redis-sentinel/bin:/opt/bitnami/common/bin:$PATH"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="7.0.4-debian-11-r16" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/redis-sentinel" \
      org.opencontainers.image.title="redis-sentinel" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="7.0.4"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libssl1.1 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f redis-sentinel-7.0.4-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/redis-sentinel-7.0.4-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "cb11fe1570d81151cf0481d2f22ff624c1c7f1922ec9235079017385f3b225c0  redis-sentinel-7.0.4-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf redis-sentinel-7.0.4-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf redis-sentinel-7.0.4-2-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab  gosu-1.14.0-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/redis-sentinel/postunpack.sh
ENV APP_VERSION="7.0.4" \
    BITNAMI_APP_NAME="redis-sentinel"

EXPOSE 26379

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/redis-sentinel/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redis-sentinel/run.sh" ]
