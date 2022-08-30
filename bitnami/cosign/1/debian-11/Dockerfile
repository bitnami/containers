FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.11.1-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/cosign" \
      org.opencontainers.image.title="cosign" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.11.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f cosign-1.11.1-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/cosign-1.11.1-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "c5ef542acf6298fe8a3b7236783ddc06ed3b4c663a85ae7a0dde48a5a78a16ca  cosign-1.11.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf cosign-1.11.1-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf cosign-1.11.1-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p "/cosign-keys" && chmod -R 777 "/cosign-keys"
RUN mkdir /.sigstore && chmod g+rwX /.sigstore

ENV APP_VERSION="1.11.1" \
    BITNAMI_APP_NAME="cosign" \
    PATH="/opt/bitnami/cosign/bin:$PATH"

WORKDIR /cosign-keys
USER 1001
ENTRYPOINT [ "cosign" ]
CMD [ "--help" ]
