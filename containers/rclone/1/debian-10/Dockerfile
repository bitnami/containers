FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/rclone-1.57.0-7-linux-amd64-debian-10.tar.gz && \
    echo "cb09b7460b04aff750d83a32c7b304409d6d5b67d1fe8cb55a6ad856e26ac58a  /tmp/bitnami/pkg/cache/rclone-1.57.0-7-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/rclone-1.57.0-7-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/rclone-1.57.0-7-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="rclone" \
    BITNAMI_IMAGE_VERSION="1.57.0-debian-10-r119" \
    PATH="/opt/bitnami/rclone/bin:$PATH"

USER 1001
ENTRYPOINT [ "rclone" ]
CMD [ "--help" ]
