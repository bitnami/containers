FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-tempo-1.4.1-0-linux-amd64-debian-11.tar.gz && \
    echo "2f66fe35eb7a3897b5d787df6288f920136faa66060dab98b5099b5755192c35  /tmp/bitnami/pkg/cache/grafana-tempo-1.4.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-tempo-1.4.1-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-tempo-1.4.1-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /bitnami/grafana-tempo && chmod g+rwX /bitnami/grafana-tempo

ENV APP_VERSION="1.4.1" \
    BITNAMI_APP_NAME="grafana-tempo" \
    PATH="/opt/bitnami/grafana-tempo/bin:$PATH"

USER 1001
ENTRYPOINT [ "tempo" ]
CMD [ "-config.file=/bitnami/grafana-tempo/conf/tempo.yaml" ]
