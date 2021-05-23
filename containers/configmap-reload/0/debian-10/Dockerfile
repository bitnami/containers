FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/configmap-reload-0.5.0-0-linux-amd64-debian-10.tar.gz && \
    echo "84d9158fc95767145f22e821b2d07410fc8374bf4b0df3a1220e9a74e11072a2  /tmp/bitnami/pkg/cache/configmap-reload-0.5.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/configmap-reload-0.5.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/configmap-reload-0.5.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/configmap-reload/bin/configmap-reload /bin/configmap-reload

ENV BITNAMI_APP_NAME="configmap-reload" \
    BITNAMI_IMAGE_VERSION="0.5.0-debian-10-r109" \
    PATH="/opt/bitnami/configmap-reload/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/configmap-reload
USER 1001
ENTRYPOINT [ "configmap-reload" ]
