FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubernetes-event-exporter-0.11.0-0-linux-amd64-debian-11.tar.gz && \
    echo "60310b056ad846e54277e6153d68f8e03154ca6097bd8be396ab941257008b67  /tmp/bitnami/pkg/cache/kubernetes-event-exporter-0.11.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubernetes-event-exporter-0.11.0-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubernetes-event-exporter-0.11.0-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="0.11.0" \
    BITNAMI_APP_NAME="kubernetes-event-exporter" \
    PATH="/opt/bitnami/kubernetes-event-exporter/bin:$PATH"

USER 1001
ENTRYPOINT [ "kubernetes-event-exporter" ]
CMD [ "--help" ]
