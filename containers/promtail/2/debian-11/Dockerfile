FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/promtail-2.5.0-1-linux-amd64-debian-11.tar.gz && \
    echo "1131ac02ffa55e192d8558d62d449a8abb6ecadab6c64a123748892717e92859  /tmp/bitnami/pkg/cache/promtail-2.5.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/promtail-2.5.0-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/promtail-2.5.0-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="2.5.0" \
    BITNAMI_APP_NAME="promtail" \
    PATH="/opt/bitnami/promtail/bin:$PATH"

USER 1001
ENTRYPOINT [ "promtail" ]
