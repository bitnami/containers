FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cosign-1.5.2-1-linux-amd64-debian-10.tar.gz && \
    echo "5b6cf3462df6a5ad74f92e21d6aaa892e30748dcdfee4b5b29878129d80a66b5  /tmp/bitnami/pkg/cache/cosign-1.5.2-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cosign-1.5.2-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cosign-1.5.2-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p "/cosign-keys" && chmod -R 777 "/cosign-keys"

ENV BITNAMI_APP_NAME="cosign" \
    BITNAMI_IMAGE_VERSION="1.5.2-debian-10-r15" \
    PATH="/opt/bitnami/cosign/bin:$PATH"

WORKDIR /cosign-keys
USER 1001
ENTRYPOINT [ "cosign" ]
CMD [ "--help" ]
