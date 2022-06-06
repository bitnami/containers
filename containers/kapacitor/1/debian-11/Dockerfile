FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kapacitor-1.6.4-0-linux-amd64-debian-11.tar.gz && \
    echo "2faedd35a3bc6b1c06d34c8eb864699697a39b68da8baff95e4a024f39f9a2f6  /tmp/bitnami/pkg/cache/kapacitor-1.6.4-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kapacitor-1.6.4-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kapacitor-1.6.4-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /bitnami/kapacitor && chmod g+rwX /bitnami/kapacitor

ENV APP_VERSION="1.6.4" \
    BITNAMI_APP_NAME="kapacitor" \
    KAPACITOR_DATA_DIR="/bitnami/kapacitor" \
    KAPACITOR_LOAD_DIR="/bitnami/kapacitor/load" \
    KAPACITOR_REPLAY_DIR="/bitnami/kapacitor/replay" \
    KAPACITOR_STORAGE_BOLTDB="/bitnami/kapacitor/kapacitor.db" \
    KAPACITOR_TASK_DIR="/bitnami/kapacitor/tasks" \
    PATH="/opt/bitnami/kapacitor/bin:$PATH"

USER 1001
CMD [ "kapacitord" ]
