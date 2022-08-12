FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.18.0-debian-11-r26" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/jsonnet" \
      org.opencontainers.image.title="jsonnet" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.18.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc-s1 libstdc++6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jsonnet-0.18.0-152-linux-amd64-debian-11.tar.gz && \
    echo "3a06f213e19330d39ab5a54204726390bda33cc49aa9820b84ca5127513b9417  /tmp/bitnami/pkg/cache/jsonnet-0.18.0-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jsonnet-0.18.0-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jsonnet-0.18.0-152-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

RUN chmod +x /opt/bitnami/jsonnet/bin/jsonnet
ENV APP_VERSION="0.18.0" \
    BITNAMI_APP_NAME="jsonnet" \
    PATH="/opt/bitnami/jsonnet/bin:$PATH"

USER 1001
ENTRYPOINT [ "jsonnet" ]
CMD [ "--help" ]
