FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/haproxy-dataplaneapi-2.4.5-0-linux-amd64-debian-10.tar.gz && \
    echo "fdf187c8d42f37c62e4638b79424e115eb9100b53879ee8a2b74284823761641  /tmp/bitnami/pkg/cache/haproxy-dataplaneapi-2.4.5-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/haproxy-dataplaneapi-2.4.5-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/haproxy-dataplaneapi-2.4.5-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/haproxy-2.5.2-1-linux-amd64-debian-10.tar.gz && \
    echo "f3df8a60779b88b85dae92d2eac34f8167c8755753eed6be40e905fe764e5ad0  /tmp/bitnami/pkg/cache/haproxy-2.5.2-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/haproxy-2.5.2-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/haproxy-2.5.2-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="haproxy" \
    BITNAMI_IMAGE_VERSION="2.5.2-debian-10-r3" \
    PATH="/opt/bitnami/haproxy-dataplaneapi/bin:/opt/bitnami/haproxy/sbin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/haproxy/sbin/haproxy" ]
CMD [ "-f", "/bitnami/haproxy/conf/haproxy.cfg" ]
