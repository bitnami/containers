FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-tempo-1.2.1-2-linux-amd64-debian-10.tar.gz && \
    echo "877a44cf53e394f441ea980de4e018c59e733064b62a6787640b1b5ca4276db5  /tmp/bitnami/pkg/cache/grafana-tempo-1.2.1-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-tempo-1.2.1-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-tempo-1.2.1-2-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /bitnami/grafana-tempo && chmod g+rwX /bitnami/grafana-tempo

ENV BITNAMI_APP_NAME="grafana-tempo" \
    BITNAMI_IMAGE_VERSION="1.2.1-debian-10-r53" \
    PATH="/opt/bitnami/grafana-tempo/bin:$PATH"

USER 1001
ENTRYPOINT [ "tempo" ]
CMD [ "-config.file=/bitnami/grafana-tempo/conf/tempo.yaml" ]
