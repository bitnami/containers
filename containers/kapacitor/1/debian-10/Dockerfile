FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kapacitor-1.6.1-0-linux-amd64-debian-10.tar.gz && \
    echo "ea5319874e46db81c25f158d05b6f97359216d99a0418e8b79a2a29e407dae37  /tmp/bitnami/pkg/cache/kapacitor-1.6.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kapacitor-1.6.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kapacitor-1.6.1-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /bitnami/kapacitor && chmod g+rwX /bitnami/kapacitor

ENV BITNAMI_APP_NAME="kapacitor" \
    BITNAMI_IMAGE_VERSION="1.6.1-debian-10-r0" \
    KAPACITOR_DATA_DIR="/bitnami/kapacitor" \
    KAPACITOR_LOAD_DIR="/bitnami/kapacitor/load" \
    KAPACITOR_REPLAY_DIR="/bitnami/kapacitor/replay" \
    KAPACITOR_STORAGE_BOLTDB="/bitnami/kapacitor/kapacitor.db" \
    KAPACITOR_TASK_DIR="/bitnami/kapacitor/tasks" \
    PATH="/opt/bitnami/kapacitor/bin:$PATH"

USER 1001
CMD [ "kapacitord" ]
