FROM docker.io/bitnami/minideb:bullseye
ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.19.0-debian-11-r9" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/golang" \
      org.opencontainers.image.title="golang" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.19.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git gzip libc6 pkg-config procps tar unzip
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f golang-1.19.0-3-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/golang-1.19.0-3-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "5ba5aeeccf6b1f10f8f97af73e3320feae4cf3a40abf2b4456c5119faf48ca04  golang-1.19.0-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf golang-1.19.0-3-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf golang-1.19.0-3-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir -p "/go/src" "/go/bin" && chmod -R 777 "/go"

ENV APP_VERSION="1.19.0" \
    BITNAMI_APP_NAME="golang" \
    GOCACHE="/go/.cache" \
    GOPATH="/go" \
    PATH="/go/bin:/opt/bitnami/go/bin:$PATH"

WORKDIR $GOPATH
CMD [ "bash" ]
