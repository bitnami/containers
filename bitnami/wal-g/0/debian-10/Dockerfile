FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wal-g-0.2.15-1-linux-amd64-debian-10.tar.gz && \
    echo "3337f8a5b8cd4d8085b1ddb6c5cd680c33043e080b76707ad59744a42e2cad01  /tmp/bitnami/pkg/cache/wal-g-0.2.15-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wal-g-0.2.15-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wal-g-0.2.15-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="wal-g" \
    BITNAMI_IMAGE_VERSION="0.2.15-debian-10-r96" \
    PATH="/opt/bitnami/wal-g/bin:$PATH"

USER 1001
ENTRYPOINT [ "wal-g" ]
CMD [ "--help" ]
