FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.6.5-debian-11-r2" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kapacitor" \
      org.opencontainers.image.title="kapacitor" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.6.5"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kapacitor-1.6.5-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kapacitor-1.6.5-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "0f2625c116214f67efec31faa7ea02e8ae6bcaed87ca42b453e75ec253d14555  kapacitor-1.6.5-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kapacitor-1.6.5-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf kapacitor-1.6.5-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /bitnami/kapacitor && chmod g+rwX /bitnami/kapacitor

ENV APP_VERSION="1.6.5" \
    BITNAMI_APP_NAME="kapacitor" \
    KAPACITOR_DATA_DIR="/bitnami/kapacitor" \
    KAPACITOR_LOAD_DIR="/bitnami/kapacitor/load" \
    KAPACITOR_REPLAY_DIR="/bitnami/kapacitor/replay" \
    KAPACITOR_STORAGE_BOLTDB="/bitnami/kapacitor/kapacitor.db" \
    KAPACITOR_TASK_DIR="/bitnami/kapacitor/tasks" \
    PATH="/opt/bitnami/kapacitor/bin:$PATH"

USER 1001
CMD [ "kapacitord" ]
