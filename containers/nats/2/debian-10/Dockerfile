FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nats-2.6.3-0-linux-amd64-debian-10.tar.gz && \
    echo "adab07e0aa141b0f2b7f863ae44c5d56009a1fe2b6b1b5932936b4a37f5e222c  /tmp/bitnami/pkg/cache/nats-2.6.3-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nats-2.6.3-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nats-2.6.3-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN chown -R 1001:root /opt/bitnami/nats && chmod g+rwX /opt/bitnami/nats
ENV BITNAMI_APP_NAME="nats" \
    BITNAMI_IMAGE_VERSION="2.6.3-debian-10-r5" \
    PATH="/opt/bitnami/nats/bin:$PATH"

EXPOSE 4222 6222 8222

WORKDIR /opt/bitnami/nats
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
