FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.20.2-debian-11-r27" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/contour" \
      org.opencontainers.image.title="contour" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.20.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/contour-1.20.2-2-linux-amd64-debian-11.tar.gz && \
    echo "e40618470a24ca340e73468526591ae9a728bd96fc168810c555f7491ae0e614  /tmp/bitnami/pkg/cache/contour-1.20.2-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/contour-1.20.2-2-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/contour-1.20.2-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/contour/bin/contour /bin/contour

ENV APP_VERSION="1.20.2" \
    BITNAMI_APP_NAME="contour" \
    PATH="/opt/bitnami/contour/bin:$PATH"

USER 1001
ENTRYPOINT [ "contour" ]
