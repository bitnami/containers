FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wal-g-1.1.0-3-linux-amd64-debian-10.tar.gz && \
    echo "40bf71510459e9376564b5fa1db32ab944ea8ceb400fc857cc2feb7a3a19982d  /tmp/bitnami/pkg/cache/wal-g-1.1.0-3-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wal-g-1.1.0-3-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wal-g-1.1.0-3-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="wal-g" \
    BITNAMI_IMAGE_VERSION="1.1.0-debian-10-r164" \
    PATH="/opt/bitnami/wal-g/bin:$PATH"

USER 1001
ENTRYPOINT [ "wal-g" ]
CMD [ "--help" ]
