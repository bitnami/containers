FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.13.4-debian-11-r5" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/metallb-controller" \
      org.opencontainers.image.title="metallb-controller" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.13.4"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/metallb-0.13.4-1-linux-amd64-debian-11.tar.gz && \
    echo "e2315f7d0cc695b00b62b9cccec82f2555c2c2fbe7b624304804f6bfe3c1f8d6  /tmp/bitnami/pkg/cache/metallb-0.13.4-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/metallb-0.13.4-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/metallb-0.13.4-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="0.13.4" \
    BITNAMI_APP_NAME="metallb-controller" \
    PATH="/opt/bitnami/metallb/bin:$PATH"

USER 1001
ENTRYPOINT [ "controller" ]
CMD [ "--help" ]
