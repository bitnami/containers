FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cert-manager-webhook-1.4.0-0-linux-amd64-debian-10.tar.gz && \
    echo "5a58fa8f4a5fca5530fdc9fd7c965145633fb90470eb719f819b5d2fb9c3769a  /tmp/bitnami/pkg/cache/cert-manager-webhook-1.4.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cert-manager-webhook-1.4.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cert-manager-webhook-1.4.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="cert-manager-webhook" \
    BITNAMI_IMAGE_VERSION="1.4.0-debian-10-r29" \
    PATH="/opt/bitnami/cert-manager-webhook/bin:$PATH"

WORKDIR /opt/bitnami/cert-manager-webhook
USER 1001
ENTRYPOINT [ "/opt/bitnami/cert-manager-webhook/bin/cert-manager-webhook" ]
