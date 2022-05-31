FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cosign-1.8.0-1-linux-amd64-debian-10.tar.gz && \
    echo "9c2f7be2ecb09e06c710ec5bc634202b00fffbf53bea5c91b1be32f87f5cc446  /tmp/bitnami/pkg/cache/cosign-1.8.0-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cosign-1.8.0-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cosign-1.8.0-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p "/cosign-keys" && chmod -R 777 "/cosign-keys"
RUN mkdir /.sigstore && chmod g+rwX /.sigstore

ENV APP_VERSION="1.8.0" \
    BITNAMI_APP_NAME="cosign" \
    PATH="/opt/bitnami/cosign/bin:$PATH"

WORKDIR /cosign-keys
USER 1001
ENTRYPOINT [ "cosign" ]
CMD [ "--help" ]
