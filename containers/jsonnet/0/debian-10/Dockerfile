FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 libstdc++6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jsonnet-0.18.0-1-linux-amd64-debian-10.tar.gz && \
    echo "851ecd0584a1573af318ffeb35855f9c08a75be5ef42e9d492e06c58ef8fd803  /tmp/bitnami/pkg/cache/jsonnet-0.18.0-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jsonnet-0.18.0-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jsonnet-0.18.0-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

RUN chmod +x /opt/bitnami/jsonnet/bin/jsonnet
ENV BITNAMI_APP_NAME="jsonnet" \
    BITNAMI_IMAGE_VERSION="0.18.0-debian-10-r21" \
    PATH="/opt/bitnami/jsonnet/bin:$PATH"

USER 1001
ENTRYPOINT [ "jsonnet" ]
CMD [ "--help" ]
