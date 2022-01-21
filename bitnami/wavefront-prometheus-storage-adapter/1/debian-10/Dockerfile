FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wavefront-prometheus-storage-adapter-1.0.5-2-linux-amd64-debian-10.tar.gz && \
    echo "efb641908769b6164935ce2e10dafeed03c7539cac2cf7d02ac1496c37c75955  /tmp/bitnami/pkg/cache/wavefront-prometheus-storage-adapter-1.0.5-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wavefront-prometheus-storage-adapter-1.0.5-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wavefront-prometheus-storage-adapter-1.0.5-2-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="wavefront-prometheus-storage-adapter" \
    BITNAMI_IMAGE_VERSION="1.0.5-debian-10-r64" \
    PATH="/opt/bitnami/wavefront-prometheus-storage-adapter/bin:$PATH"

USER 1001
ENTRYPOINT [ "adapter" ]
CMD [ "--help" ]
