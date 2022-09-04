FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/redis-sentinel/bin:/opt/bitnami/common/bin:$PATH"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="6.2.7-debian-11-r34" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/redis-sentinel" \
      org.opencontainers.image.title="redis-sentinel" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="6.2.7"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libssl1.1 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f redis-sentinel-6.2.7-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/redis-sentinel-6.2.7-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "fbaf525ae91f975cbad916daa68233f3851c05f919f747d6657216b9ae1c8d58  redis-sentinel-6.2.7-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf redis-sentinel-6.2.7-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf redis-sentinel-6.2.7-153-linux-amd64-debian-11.tar.gz
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
ENV APP_VERSION="6.2.7" \
    BITNAMI_APP_NAME="redis-sentinel"

EXPOSE 26379

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/redis-sentinel/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redis-sentinel/run.sh" ]
