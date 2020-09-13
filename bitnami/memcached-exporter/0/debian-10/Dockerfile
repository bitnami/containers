FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/memcached-exporter-0.7.0-0-linux-amd64-debian-10.tar.gz && \
    echo "296c127b6d26b9de952ecb7f79df0628b81b41cd86387d7b491ecf9368dbb0e3  /tmp/bitnami/pkg/cache/memcached-exporter-0.7.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/memcached-exporter-0.7.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/memcached-exporter-0.7.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="memcached-exporter" \
    BITNAMI_IMAGE_VERSION="0.7.0-debian-10-r38" \
    PATH="/opt/bitnami/memcached-exporter/bin:$PATH"

EXPOSE 9150

WORKDIR /opt/bitnami/memcached-exporter
USER 1001
ENTRYPOINT [ "memcached_exporter" ]
