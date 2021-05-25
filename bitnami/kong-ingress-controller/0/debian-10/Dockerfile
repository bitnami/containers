FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wait-for-port-1.0.0-3-linux-amd64-debian-10.tar.gz && \
    echo "7521d9a4f9e4e182bf32977e234026caa7b03759799868335bccb1edd8f8fd12  /tmp/bitnami/pkg/cache/wait-for-port-1.0.0-3-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wait-for-port-1.0.0-3-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wait-for-port-1.0.0-3-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kong-ingress-controller-0.10.0-1-linux-amd64-debian-10.tar.gz && \
    echo "d9bc5e9bd17e3f031281dac7294de3df1f5b309eb76f9596ca9628f0f228ddfe  /tmp/bitnami/pkg/cache/kong-ingress-controller-0.10.0-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kong-ingress-controller-0.10.0-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kong-ingress-controller-0.10.0-1-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="kong-ingress-controller" \
    BITNAMI_IMAGE_VERSION="0.10.0-debian-10-r235" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/kong-ingress-controller/bin:$PATH"

USER 1001
ENTRYPOINT [ "kong-ingress-controller" ]
CMD [ "--help" ]
