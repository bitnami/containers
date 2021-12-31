FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.8.12-8-linux-amd64-debian-10.tar.gz && \
    echo "7301922567971177586341f93f851616f5488c575de2fb256c38de725907c341  /tmp/bitnami/pkg/cache/python-3.8.12-8-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.8.12-8-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.8.12-8-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-14.18.2-0-linux-amd64-debian-10.tar.gz && \
    echo "5753bbbe5052000888c24ef8c918cfc45577878b03cc4dcfe7d53ea562a48e5a  /tmp/bitnami/pkg/cache/node-14.18.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-14.18.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-14.18.2-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/configurable-http-proxy-4.5.0-0-linux-amd64-debian-10.tar.gz && \
    echo "b84a97b61f29f918affd172ecf424bd8326e39509f9549e7ab211d7e88a7544c  /tmp/bitnami/pkg/cache/configurable-http-proxy-4.5.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/configurable-http-proxy-4.5.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/configurable-http-proxy-4.5.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="configurable-http-proxy" \
    BITNAMI_IMAGE_VERSION="4.5.0-debian-10-r160" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/configurable-http-proxy/bin:$PATH"

EXPOSE 3000

USER 1001
ENTRYPOINT [ "configurable-http-proxy" ]
