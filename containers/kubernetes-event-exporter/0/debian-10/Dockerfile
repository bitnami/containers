FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubernetes-event-exporter-0.10.0-0-linux-amd64-debian-10.tar.gz && \
    echo "ad3ce1cd45c4a44fc761f5f9fd45a554418fd3a55d08a68398d7a46a9fccd546  /tmp/bitnami/pkg/cache/kubernetes-event-exporter-0.10.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubernetes-event-exporter-0.10.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubernetes-event-exporter-0.10.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="kubernetes-event-exporter" \
    BITNAMI_IMAGE_VERSION="0.10.0-debian-10-r130" \
    PATH="/opt/bitnami/kubernetes-event-exporter/bin:$PATH"

USER 1001
ENTRYPOINT [ "kubernetes-event-exporter" ]
CMD [ "--help" ]
