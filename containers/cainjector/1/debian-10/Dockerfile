FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cainjector-1.7.0-0-linux-amd64-debian-10.tar.gz && \
    echo "783df4a142377fc1cfdf85d0fed20f29b7b6f366907abb72f08f64574a980f9c  /tmp/bitnami/pkg/cache/cainjector-1.7.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cainjector-1.7.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cainjector-1.7.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="cainjector" \
    BITNAMI_IMAGE_VERSION="1.7.0-debian-10-r1" \
    PATH="/opt/bitnami/cainjector/bin:$PATH"

WORKDIR /opt/bitnami/cainjector
USER 1001
ENTRYPOINT [ "/opt/bitnami/cainjector/bin/cainjector" ]
