FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.9.1-debian-11-r18" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/tensorflow-resnet" \
      org.opencontainers.image.title="tensorflow-resnet" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.9.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gcc-10 gzip libc6 libgcc-s1 libstdc++6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f tensorflow-resnet-2.9.1-3-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/tensorflow-resnet-2.9.1-3-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "991eef5bf501c339b46e3ec5a47bba1ffe7f2cf8151cb199d89f17ec085b0589  tensorflow-resnet-2.9.1-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf tensorflow-resnet-2.9.1-3-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf tensorflow-resnet-2.9.1-3-linux-amd64-debian-11.tar.gz
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
ENV APP_VERSION="2.9.1" \
    BITNAMI_APP_NAME="tensorflow-resnet" \
    PATH="/opt/bitnami/tensorflow-resnet/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/tensorflow-resnet/entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
