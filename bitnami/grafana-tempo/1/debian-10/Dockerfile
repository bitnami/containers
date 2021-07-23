FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-tempo-1.0.1-0-linux-amd64-debian-10.tar.gz && \
    echo "3932808820d5dd257c33c6e4c371673605a5eb9bee012dc07da045ab552a11c7  /tmp/bitnami/pkg/cache/grafana-tempo-1.0.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-tempo-1.0.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-tempo-1.0.1-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="grafana-tempo" \
    BITNAMI_IMAGE_VERSION="1.0.1-debian-10-r14" \
    PATH="/opt/bitnami/grafana-tempo/bin:$PATH"

USER 1001
ENTRYPOINT [ "tempo" ]
CMD [ "-config.file=/bitnami/grafana-tempo/conf/tempo.yaml" ]
