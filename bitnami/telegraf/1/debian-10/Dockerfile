FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/telegraf-1.16.0-0-linux-amd64-debian-10.tar.gz && \
    echo "ede4989b55257ea4e7651ca7dcfdb03203e2ca559c63f7a65bb0b18d8674aaa7  /tmp/bitnami/pkg/cache/telegraf-1.16.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/telegraf-1.16.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/telegraf-1.16.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="telegraf" \
    BITNAMI_IMAGE_VERSION="1.16.0-debian-10-r0" \
    PATH="/opt/bitnami/telegraf/bin:$PATH"

USER 1001
ENTRYPOINT [ "telegraf" ]
CMD [ "--help" ]
