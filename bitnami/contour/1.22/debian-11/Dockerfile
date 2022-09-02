FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.22.0-debian-11-r11" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/contour" \
      org.opencontainers.image.title="contour" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.22.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f contour-1.22.0-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/contour-1.22.0-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e334ff5d20bbdd5445c100c1012efbf8b6f14d3d3aff8117bbe752541c95c4cd  contour-1.22.0-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf contour-1.22.0-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf contour-1.22.0-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/contour/bin/contour /bin/contour

ENV APP_VERSION="1.22.0" \
    BITNAMI_APP_NAME="contour" \
    PATH="/opt/bitnami/contour/bin:$PATH"

USER 1001
ENTRYPOINT [ "contour" ]
