FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/haproxy-dataplaneapi-2.4.4-2-linux-amd64-debian-10.tar.gz && \
    echo "f1692ddebc8ba089a073ddd28564426620ead9c6c5cd82e7e8e99e79a67467e0  /tmp/bitnami/pkg/cache/haproxy-dataplaneapi-2.4.4-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/haproxy-dataplaneapi-2.4.4-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/haproxy-dataplaneapi-2.4.4-2-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/haproxy-2.5.1-2-linux-amd64-debian-10.tar.gz && \
    echo "c0e5e19ddc794fbbded38bc55568f026e8be734ca21b0df6b962dda41285d3a8  /tmp/bitnami/pkg/cache/haproxy-2.5.1-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/haproxy-2.5.1-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/haproxy-2.5.1-2-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="haproxy" \
    BITNAMI_IMAGE_VERSION="2.5.1-debian-10-r28" \
    PATH="/opt/bitnami/haproxy-dataplaneapi/bin:/opt/bitnami/haproxy/sbin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/haproxy/sbin/haproxy" ]
CMD [ "-f", "/bitnami/haproxy/conf/haproxy.cfg" ]
