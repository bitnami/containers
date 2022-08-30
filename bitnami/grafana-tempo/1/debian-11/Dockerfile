FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.5.0-debian-11-r4" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/grafana-tempo" \
      org.opencontainers.image.title="grafana-tempo" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.5.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f grafana-tempo-1.5.0-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/grafana-tempo-1.5.0-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "ab264e7bdd8de6aa3eb40a44c618cf555da51025ee9b4a9aead658feec3c2ffb  grafana-tempo-1.5.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf grafana-tempo-1.5.0-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf grafana-tempo-1.5.0-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /bitnami/grafana-tempo && chmod g+rwX /bitnami/grafana-tempo

ENV APP_VERSION="1.5.0" \
    BITNAMI_APP_NAME="grafana-tempo" \
    PATH="/opt/bitnami/grafana-tempo/bin:$PATH"

USER 1001
ENTRYPOINT [ "tempo" ]
CMD [ "-config.file=/bitnami/grafana-tempo/conf/tempo.yaml" ]
