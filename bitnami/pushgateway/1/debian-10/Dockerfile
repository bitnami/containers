FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/pushgateway-1.4.1-0-linux-amd64-debian-10.tar.gz && \
    echo "68178f760626480e9298657bcd8c47a73c2dface570de2bdcfc6c46893739886  /tmp/bitnami/pkg/cache/pushgateway-1.4.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/pushgateway-1.4.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/pushgateway-1.4.1-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="pushgateway" \
    BITNAMI_IMAGE_VERSION="1.4.1-debian-10-r8" \
    PATH="/opt/bitnami/pushgateway/bin:$PATH"

EXPOSE 9091

WORKDIR /opt/bitnami/pushgateway
USER 1001
ENTRYPOINT [ "/opt/bitnami/pushgateway/bin/pushgateway" ]
