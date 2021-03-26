FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/contour-1.13.1-0-linux-amd64-debian-10.tar.gz && \
    echo "d754109ebacf3a3d5df29f1f582ff1a2f68167ffc56ab77b815b6ffbb7e4e0bc  /tmp/bitnami/pkg/cache/contour-1.13.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/contour-1.13.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/contour-1.13.1-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="contour" \
    BITNAMI_IMAGE_VERSION="1.13.1-debian-10-r19" \
    PATH="/opt/bitnami/contour/bin:$PATH"

USER 1001
ENTRYPOINT [ "contour" ]
