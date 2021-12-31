FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wait-for-port-1.0.1-4-linux-amd64-debian-10.tar.gz && \
    echo "53c0f1a5361a68c298f31f6701c8e8a026e77f09805d54ecfeb52cf5998d7d06  /tmp/bitnami/pkg/cache/wait-for-port-1.0.1-4-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wait-for-port-1.0.1-4-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wait-for-port-1.0.1-4-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kong-ingress-controller-1.3.1-1-linux-amd64-debian-10.tar.gz && \
    echo "e0d86a6e6198d64edb03b54c407037f04387b78a4a18ee56f2cbff4d220237e5  /tmp/bitnami/pkg/cache/kong-ingress-controller-1.3.1-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kong-ingress-controller-1.3.1-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kong-ingress-controller-1.3.1-1-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="kong-ingress-controller" \
    BITNAMI_IMAGE_VERSION="1.3.1-debian-10-r193" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/kong-ingress-controller/bin:$PATH"

USER 1001
ENTRYPOINT [ "kong-ingress-controller" ]
CMD [ "--help" ]
