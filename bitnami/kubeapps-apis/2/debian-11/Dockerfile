FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.5.0-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kubeapps-apis" \
      org.opencontainers.image.title="kubeapps-apis" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.5.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubeapps-apis-2.5.0-0-linux-amd64-debian-11.tar.gz && \
    echo "290f3d08066a622e1ba4a91cfbe9af5174867c4b7daf289ca6f34dbd2e311ea7  /tmp/bitnami/pkg/cache/kubeapps-apis-2.5.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubeapps-apis-2.5.0-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubeapps-apis-2.5.0-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/kubeapps-apis/plugins /plugins && ln -s /opt/bitnami/kubeapps-apis/bin/kubeapps-apis /kubeapps-apis

ENV APP_VERSION="2.5.0" \
    BITNAMI_APP_NAME="kubeapps-apis" \
    PATH="/opt/bitnami/kubeapps-apis/bin:$PATH"

EXPOSE 50051

USER 1001
ENTRYPOINT [ "kubeapps-apis" ]
CMD [ "--help" ]
