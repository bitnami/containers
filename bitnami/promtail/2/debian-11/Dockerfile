FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/promtail-2.6.1-0-linux-amd64-debian-11.tar.gz && \
    echo "2807614edfdb615dac69ff43e99ed24a5a2c5c2d22ee7a0e9747d0d0d9433b9b  /tmp/bitnami/pkg/cache/promtail-2.6.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/promtail-2.6.1-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/promtail-2.6.1-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="2.6.1" \
    BITNAMI_APP_NAME="promtail" \
    PATH="/opt/bitnami/promtail/bin:$PATH"

USER 1001
ENTRYPOINT [ "promtail" ]
