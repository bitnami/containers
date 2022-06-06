FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wavefront-prometheus-storage-adapter-1.0.5-0-linux-amd64-debian-11.tar.gz && \
    echo "76c0b0a1532620649dbe8c3fc77e9ffbc71e3c294c1e0cda0f408ff249d7746b  /tmp/bitnami/pkg/cache/wavefront-prometheus-storage-adapter-1.0.5-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wavefront-prometheus-storage-adapter-1.0.5-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wavefront-prometheus-storage-adapter-1.0.5-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.0.5" \
    BITNAMI_APP_NAME="wavefront-prometheus-storage-adapter" \
    PATH="/opt/bitnami/wavefront-prometheus-storage-adapter/bin:$PATH"

USER 1001
ENTRYPOINT [ "adapter" ]
CMD [ "--help" ]
