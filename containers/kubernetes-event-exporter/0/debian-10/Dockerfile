FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubernetes-event-exporter-0.11.0-0-linux-amd64-debian-10.tar.gz && \
    echo "9b5538f8825e7fecf0429e796b1961a10a667c8e0d378e99603b39e9ea682635  /tmp/bitnami/pkg/cache/kubernetes-event-exporter-0.11.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubernetes-event-exporter-0.11.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubernetes-event-exporter-0.11.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="kubernetes-event-exporter" \
    BITNAMI_IMAGE_VERSION="0.11.0-debian-10-r44" \
    PATH="/opt/bitnami/kubernetes-event-exporter/bin:$PATH"

USER 1001
ENTRYPOINT [ "kubernetes-event-exporter" ]
CMD [ "--help" ]
