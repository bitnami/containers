FROM bitnami/oraclelinux-extras:7-r135 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nats-1.3.0-2-linux-x86_64-ol-7.tar.gz && \
    echo "01bcb5a05bc9503fb5a8f94f251ab4dfd5d58ff33ab2fec01b411f39fe606b06  /tmp/bitnami/pkg/cache/nats-1.3.0-2-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nats-1.3.0-2-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nats-1.3.0-2-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r135
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/nats /opt/bitnami/nats
ENV BITNAMI_APP_NAME="nats" \
    BITNAMI_IMAGE_VERSION="1.3.0-ol-7-r44" \
    PATH="/opt/bitnami/nats/bin:$PATH"

RUN install_packages curl
RUN chown -R 1001:1001 /opt/bitnami/nats

EXPOSE 4222 6222 8222

COPY rootfs /
WORKDIR /opt/bitnami/nats
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
