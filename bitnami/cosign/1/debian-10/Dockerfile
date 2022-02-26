FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cosign-1.5.2-0-linux-amd64-debian-10.tar.gz && \
    echo "20ee843a8dc4ea079751bf2783555925befb126d245df10f287e806aea2ecd28  /tmp/bitnami/pkg/cache/cosign-1.5.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cosign-1.5.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cosign-1.5.2-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p "/cosign-keys" && chmod -R 777 "/cosign-keys"

ENV BITNAMI_APP_NAME="cosign" \
    BITNAMI_IMAGE_VERSION="1.5.2-debian-10-r6" \
    PATH="/opt/bitnami/cosign/bin:$PATH"

WORKDIR /cosign-keys
USER 1001
ENTRYPOINT [ "cosign" ]
CMD [ "--help" ]
