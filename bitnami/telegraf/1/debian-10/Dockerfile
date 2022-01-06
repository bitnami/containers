FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/telegraf-1.21.2-0-linux-amd64-debian-10.tar.gz && \
    echo "e037a544a3e58c65483229231f6159685a9f620f01ab6791d185e33f6c464f21  /tmp/bitnami/pkg/cache/telegraf-1.21.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/telegraf-1.21.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/telegraf-1.21.2-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="telegraf" \
    BITNAMI_IMAGE_VERSION="1.21.2-debian-10-r0" \
    PATH="/opt/bitnami/telegraf/bin:$PATH"

USER 1001
ENTRYPOINT [ "telegraf" ]
CMD [ "--help" ]
