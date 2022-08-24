FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.21.1-debian-11-r24" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/contour" \
      org.opencontainers.image.title="contour" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.21.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/contour-1.21.1-2-linux-amd64-debian-11.tar.gz && \
    echo "5243ebe174f8785e4f5a7ae6a0b092800806bd4f85f18c09b8b0aa4c09cb3530  /tmp/bitnami/pkg/cache/contour-1.21.1-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/contour-1.21.1-2-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/contour-1.21.1-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/contour/bin/contour /bin/contour

ENV APP_VERSION="1.21.1" \
    BITNAMI_APP_NAME="contour" \
    PATH="/opt/bitnami/contour/bin:$PATH"

USER 1001
ENTRYPOINT [ "contour" ]
