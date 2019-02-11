FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nats-1.4.1-0-linux-x86_64-rhel-7.tar.gz && \
    echo "ef017cd2eecf7a8436e86a657a96a2dd5458816add1fb69e91f4d2f819478a21  /tmp/bitnami/pkg/cache/nats-1.4.1-0-linux-x86_64-rhel-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nats-1.4.1-0-linux-x86_64-rhel-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nats-1.4.1-0-linux-x86_64-rhel-7.tar.gz

COPY rootfs /
RUN chown -R 1001:root /opt/bitnami/nats && chmod g+rwX /opt/bitnami/nats
ENV BITNAMI_APP_NAME="nats" \
    BITNAMI_IMAGE_VERSION="1.4.1-rhel-7-r4" \
    BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/nats/bin:$PATH"

EXPOSE 4222 6222 8222

WORKDIR /opt/bitnami/nats
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
