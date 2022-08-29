FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.7.1-debian-11-r31" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/configmap-reload" \
      org.opencontainers.image.title="configmap-reload" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.7.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f configmap-reload-0.7.1-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/configmap-reload-0.7.1-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "d57038b61463ec0cc42238db8a2426a030eaf6643e447321374f4c3798bcf1ff  configmap-reload-0.7.1-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf configmap-reload-0.7.1-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf configmap-reload-0.7.1-153-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/configmap-reload/bin/configmap-reload /bin/configmap-reload

ENV APP_VERSION="0.7.1" \
    BITNAMI_APP_NAME="configmap-reload" \
    PATH="/opt/bitnami/configmap-reload/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/configmap-reload
USER 1001
ENTRYPOINT [ "configmap-reload" ]
