FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.2.2-debian-11-r32" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/couchdb" \
      org.opencontainers.image.title="couchdb" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.2.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc-s1 libicu67 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f wait-for-port-1.0.3-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/wait-for-port-1.0.3-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "74a09c2208af7316f32ee3ee8479d70b20ad54f1a989e84b6417e23c1f07c147  wait-for-port-1.0.3-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf wait-for-port-1.0.3-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf wait-for-port-1.0.3-154-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f ini-file-1.4.3-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/ini-file-1.4.3-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "4692a063a41c8382fbf1629f92bb91cc3064d50b25bddeb7e1b299c749e39afd  ini-file-1.4.3-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf ini-file-1.4.3-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf ini-file-1.4.3-153-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab  gosu-1.14.0-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f couchdb-3.2.2-155-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/couchdb-3.2.2-155-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "d6373aad74f24d4a17dfc94528e03807bcd486e68744dc5af919ca203a3ab697  couchdb-3.2.2-155-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf couchdb-3.2.2-155-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf couchdb-3.2.2-155-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/couchdb/postunpack.sh
ENV APP_VERSION="3.2.2" \
    BITNAMI_APP_NAME="couchdb" \
    LD_LIBRARY_PATH="/opt/bitnami/common/lib:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/couchdb/bin:$PATH"

VOLUME [ "/bitnami/couchdb" ]

EXPOSE 4369 5984 9100

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/couchdb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/couchdb/run.sh" ]
