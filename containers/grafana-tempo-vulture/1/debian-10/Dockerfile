FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-tempo-vulture-1.2.1-0-linux-amd64-debian-10.tar.gz && \
    echo "74e04d3efd946d53ec422f1c7a7f2be2cd58c9796887dcc36341dcb75c565eac  /tmp/bitnami/pkg/cache/grafana-tempo-vulture-1.2.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-tempo-vulture-1.2.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-tempo-vulture-1.2.1-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="grafana-tempo-vulture" \
    BITNAMI_IMAGE_VERSION="1.2.1-debian-10-r50" \
    PATH="/opt/bitnami/grafana-tempo-vulture/bin:$PATH"

USER 1001
ENTRYPOINT [ "tempo-vulture" ]
CMD [ "--help" ]
