FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-tempo-vulture-1.4.1-0-linux-amd64-debian-11.tar.gz && \
    echo "87a7b4e5c8797853e56092c7c7b2a8a7201f898888839ba8b402e25e2fc6b438  /tmp/bitnami/pkg/cache/grafana-tempo-vulture-1.4.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-tempo-vulture-1.4.1-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-tempo-vulture-1.4.1-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.4.1" \
    BITNAMI_APP_NAME="grafana-tempo-vulture" \
    PATH="/opt/bitnami/grafana-tempo-vulture/bin:$PATH"

USER 1001
ENTRYPOINT [ "tempo-vulture" ]
CMD [ "--help" ]
