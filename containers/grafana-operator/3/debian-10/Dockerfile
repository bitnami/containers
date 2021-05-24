FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-operator-3.10.1-0-linux-amd64-debian-10.tar.gz && \
    echo "8eb497c07c060fccfa9bed7dd8ac07ac4790b1c4001491d77b438adeb05b7970  /tmp/bitnami/pkg/cache/grafana-operator-3.10.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-operator-3.10.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-operator-3.10.1-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/grafana-operator/bin/grafana-operator /usr/local/bin/grafana-operator
RUN mkdir -p /opt/jsonnet && ln -sf /opt/bitnami/grafonnet-lib/grafonnet /opt/jsonnet/grafonnet

ENV BITNAMI_APP_NAME="grafana-operator" \
    BITNAMI_IMAGE_VERSION="3.10.1-debian-10-r9" \
    PATH="/opt/bitnami/grafana-operator/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/grafana-operator
USER 1001
ENTRYPOINT [ "grafana-operator" ]
