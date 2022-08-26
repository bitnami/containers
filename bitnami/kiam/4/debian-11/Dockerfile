FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="4.2.0-debian-11-r30" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kiam" \
      org.opencontainers.image.title="kiam" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="4.2.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip iptables procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kiam-4.2.0-152-linux-amd64-debian-11.tar.gz && \
    echo "a5289dffc457b9465b6f5a9985b94fa01d71ab11a8defe1597adac2e1cc76bb4  /tmp/bitnami/pkg/cache/kiam-4.2.0-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kiam-4.2.0-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kiam-4.2.0-152-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy && \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

ENV APP_VERSION="4.2.0" \
    BITNAMI_APP_NAME="kiam" \
    PATH="/opt/bitnami/kiam/bin:$PATH"

USER 1001
ENTRYPOINT [ "kiam" ]
CMD [ "--help" ]
