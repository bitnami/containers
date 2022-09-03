FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.5.1-debian-11-r1" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kubeapps-pinniped-proxy" \
      org.opencontainers.image.title="kubeapps-pinniped-proxy" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.5.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc-s1 libssl1.1 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kubeapps-pinniped-proxy-2.5.1-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kubeapps-pinniped-proxy-2.5.1-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "b002f454a498bfac44ef792172c5f4ed4cde9e91a44c15215c323b6b453f378e  kubeapps-pinniped-proxy-2.5.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kubeapps-pinniped-proxy-2.5.1-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf kubeapps-pinniped-proxy-2.5.1-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="2.5.1" \
    BITNAMI_APP_NAME="kubeapps-pinniped-proxy" \
    PATH="/opt/bitnami/kubeapps-pinniped-proxy/bin:$PATH"

USER 1001
ENTRYPOINT [ "pinniped-proxy" ]
CMD [ "--help" ]
