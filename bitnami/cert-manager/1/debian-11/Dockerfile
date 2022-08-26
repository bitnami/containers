FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.9.1-debian-11-r12" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/cert-manager" \
      org.opencontainers.image.title="cert-manager" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.9.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    curl -SsLf https://downloads.bitnami.com/files/stacksmith/cert-manager-1.9.1-1-linux-amd64-debian-11.tar.gz -o cert-manager-1.9.1-1-linux-amd64-debian-11.tar.gz && \
    echo "f58e2915e0e284b0a2757fdcffdcb5cb77512cf9671377455492f43e6bf4208d  cert-manager-1.9.1-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf cert-manager-1.9.1-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf cert-manager-1.9.1-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.9.1" \
    BITNAMI_APP_NAME="cert-manager" \
    PATH="/opt/bitnami/cert-manager/bin:$PATH"

WORKDIR /opt/bitnami/cert-manager
USER 1001
ENTRYPOINT [ "/opt/bitnami/cert-manager/bin/cert-manager" ]
