FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="4.6.0-debian-11-r2" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/grafana-operator" \
      org.opencontainers.image.title="grafana-operator" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="4.6.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-operator-4.6.0-0-linux-amd64-debian-11.tar.gz && \
    echo "ccd3103269f40f1277f41218f403ce388f07552aeb88afcde5c28a18370d510c  /tmp/bitnami/pkg/cache/grafana-operator-4.6.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-operator-4.6.0-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-operator-4.6.0-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/grafana-operator/bin/grafana-operator /usr/local/bin/grafana-operator
RUN mkdir -p /opt/jsonnet && ln -sf /opt/bitnami/grafonnet-lib/grafonnet /opt/jsonnet/grafonnet

ENV APP_VERSION="4.6.0" \
    BITNAMI_APP_NAME="grafana-operator" \
    PATH="/opt/bitnami/grafana-operator/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/grafana-operator
USER 1001
ENTRYPOINT [ "grafana-operator" ]
