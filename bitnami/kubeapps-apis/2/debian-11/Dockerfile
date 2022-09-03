FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.5.1-debian-11-r1" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kubeapps-apis" \
      org.opencontainers.image.title="kubeapps-apis" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.5.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kubeapps-apis-2.5.1-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kubeapps-apis-2.5.1-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "107ea74661167b894dd55360393717cf85d4c7caf1eeedd5b5d5a1181c24caee  kubeapps-apis-2.5.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kubeapps-apis-2.5.1-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf kubeapps-apis-2.5.1-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/kubeapps-apis/plugins /plugins && ln -s /opt/bitnami/kubeapps-apis/bin/kubeapps-apis /kubeapps-apis

ENV APP_VERSION="2.5.1" \
    BITNAMI_APP_NAME="kubeapps-apis" \
    PATH="/opt/bitnami/kubeapps-apis/bin:$PATH"

EXPOSE 50051

USER 1001
ENTRYPOINT [ "kubeapps-apis" ]
CMD [ "--help" ]
