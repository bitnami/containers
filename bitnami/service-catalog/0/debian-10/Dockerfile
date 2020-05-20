FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/service-catalog-0.2.3-0-linux-amd64-debian-10.tar.gz && \
    echo "c103bd04a9b466c491d0e8f613956897cd492383827a069ba4fd80b4c6c619c3  /tmp/bitnami/pkg/cache/service-catalog-0.2.3-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/service-catalog-0.2.3-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/service-catalog-0.2.3-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="service-catalog" \
    BITNAMI_IMAGE_VERSION="0.2.3-debian-10-r0" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/service-catalog/bin:$PATH"

EXPOSE 8443 443

WORKDIR /opt/bitnami/service-catalog
USER 1001
ENTRYPOINT [ "/opt/bitnami/service-catalog/bin/service-catalog" ]
