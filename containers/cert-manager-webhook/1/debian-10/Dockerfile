FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cert-manager-webhook-1.5.4-0-linux-amd64-debian-10.tar.gz && \
    echo "0870109a3532f4519e464bb5a307862ff89076f9b3f066ccd4a26e1f8f1d7c8e  /tmp/bitnami/pkg/cache/cert-manager-webhook-1.5.4-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cert-manager-webhook-1.5.4-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cert-manager-webhook-1.5.4-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="cert-manager-webhook" \
    BITNAMI_IMAGE_VERSION="1.5.4-debian-10-r23" \
    PATH="/opt/bitnami/cert-manager-webhook/bin:$PATH"

WORKDIR /opt/bitnami/cert-manager-webhook
USER 1001
ENTRYPOINT [ "/opt/bitnami/cert-manager-webhook/bin/cert-manager-webhook" ]
