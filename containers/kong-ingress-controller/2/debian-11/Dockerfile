FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wait-for-port-1.0.3-150-linux-amd64-debian-11.tar.gz && \
    echo "1013e2ebbe58e5dc8f3c79fc952f020fc5306ba48463803cacfbed7779173924  /tmp/bitnami/pkg/cache/wait-for-port-1.0.3-150-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wait-for-port-1.0.3-150-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wait-for-port-1.0.3-150-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kong-ingress-controller-2.4.2-0-linux-amd64-debian-11.tar.gz && \
    echo "6200f3001cd2b2f7fd2f65b54c7c065266bf00f83a78e39ae95a83d2ade48d53  /tmp/bitnami/pkg/cache/kong-ingress-controller-2.4.2-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kong-ingress-controller-2.4.2-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kong-ingress-controller-2.4.2-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="2.4.2" \
    BITNAMI_APP_NAME="kong-ingress-controller" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/kong-ingress-controller/bin:$PATH"

USER 1001
ENTRYPOINT [ "kong-ingress-controller" ]
CMD [ "--help" ]
