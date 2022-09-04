FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.9.1-debian-11-r14" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/cainjector" \
      org.opencontainers.image.title="cainjector" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.9.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f cainjector-1.9.1-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/cainjector-1.9.1-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "43b8ee41f12f868d15d5658c3092c8e7a490546747439101c2281b4b48da4e10  cainjector-1.9.1-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf cainjector-1.9.1-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf cainjector-1.9.1-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.9.1" \
    BITNAMI_APP_NAME="cainjector" \
    PATH="/opt/bitnami/cainjector/bin:$PATH"

WORKDIR /opt/bitnami/cainjector
USER 1001
ENTRYPOINT [ "/opt/bitnami/cainjector/bin/cainjector" ]
