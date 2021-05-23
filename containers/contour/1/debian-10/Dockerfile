FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/contour-1.15.1-0-linux-amd64-debian-10.tar.gz && \
    echo "aec1b6534a583327b12114dabb78e6edc61b39b0cbb4a5f79100b44900ac64c2  /tmp/bitnami/pkg/cache/contour-1.15.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/contour-1.15.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/contour-1.15.1-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="contour" \
    BITNAMI_IMAGE_VERSION="1.15.1-debian-10-r9" \
    PATH="/opt/bitnami/contour/bin:$PATH"

USER 1001
ENTRYPOINT [ "contour" ]
