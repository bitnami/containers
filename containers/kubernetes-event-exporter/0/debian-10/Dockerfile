FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubernetes-event-exporter-0.9.0-2-linux-amd64-debian-10.tar.gz && \
    echo "5fdf89bf970074f44a027d1cb7bf28938844736da61cb2799500b8ee1a9972d9  /tmp/bitnami/pkg/cache/kubernetes-event-exporter-0.9.0-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubernetes-event-exporter-0.9.0-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubernetes-event-exporter-0.9.0-2-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="kubernetes-event-exporter" \
    BITNAMI_IMAGE_VERSION="0.9.0-debian-10-r165" \
    PATH="/opt/bitnami/kubernetes-event-exporter/bin:$PATH"

USER 1001
ENTRYPOINT [ "kubernetes-event-exporter" ]
CMD [ "--help" ]
