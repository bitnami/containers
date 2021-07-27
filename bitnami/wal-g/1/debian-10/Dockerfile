FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wal-g-1.0.0-0-linux-amd64-debian-10.tar.gz && \
    echo "0b567395c6529b3703dc4b06fe65dd956cd2712c2ce1cf0ebbab47ec45f16b5d  /tmp/bitnami/pkg/cache/wal-g-1.0.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wal-g-1.0.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wal-g-1.0.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="wal-g" \
    BITNAMI_IMAGE_VERSION="1.0.0-debian-10-r36" \
    PATH="/opt/bitnami/wal-g/bin:$PATH"

USER 1001
ENTRYPOINT [ "wal-g" ]
CMD [ "--help" ]
