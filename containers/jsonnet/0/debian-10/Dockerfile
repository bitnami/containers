FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 libstdc++6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jsonnet-0.18.0-6-linux-amd64-debian-10.tar.gz && \
    echo "7a68e23dc1e6adf721ff5af0a8fa78b232287e4d6cb8c084781b3719972f8a7f  /tmp/bitnami/pkg/cache/jsonnet-0.18.0-6-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jsonnet-0.18.0-6-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jsonnet-0.18.0-6-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

RUN chmod +x /opt/bitnami/jsonnet/bin/jsonnet
ENV BITNAMI_APP_NAME="jsonnet" \
    BITNAMI_IMAGE_VERSION="0.18.0-debian-10-r56" \
    PATH="/opt/bitnami/jsonnet/bin:$PATH"

USER 1001
ENTRYPOINT [ "jsonnet" ]
CMD [ "--help" ]
