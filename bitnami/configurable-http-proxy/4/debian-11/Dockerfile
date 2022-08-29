FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="4.5.2-debian-11-r2" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/configurable-http-proxy" \
      org.opencontainers.image.title="configurable-http-proxy" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="4.5.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps tar zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f python-3.8.13-166-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/python-3.8.13-166-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "9a5fba755f6c8d60eacc80f366f3fbaa57d003913e48c31ba337037bb69e37b3  python-3.8.13-166-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf python-3.8.13-166-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf python-3.8.13-166-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f node-14.20.0-3-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/node-14.20.0-3-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "49946e0443d8f479f296c79589fea205126b6f6faa6b4474e5dd713b36d8167c  node-14.20.0-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf node-14.20.0-3-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf node-14.20.0-3-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f configurable-http-proxy-4.5.2-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/configurable-http-proxy-4.5.2-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "ce269e503dac6869c96794677fb4521dc0fa1015d8deab4777781dde08707402  configurable-http-proxy-4.5.2-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf configurable-http-proxy-4.5.2-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf configurable-http-proxy-4.5.2-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="4.5.2" \
    BITNAMI_APP_NAME="configurable-http-proxy" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/configurable-http-proxy/bin:$PATH"

EXPOSE 3000

USER 1001
ENTRYPOINT [ "configurable-http-proxy" ]
