FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nats-1.2.0-7-linux-amd64-debian-9.tar.gz && \
    echo "59e42cba877f9de0dea5919011e07ed15d4ff3360092704b4c06eabbc2ca9db8  /tmp/bitnami/pkg/cache/nats-1.2.0-7-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nats-1.2.0-7-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nats-1.2.0-7-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/nats /opt/bitnami/nats
ENV BITNAMI_APP_NAME="nats" \
    BITNAMI_IMAGE_VERSION="1.2.0-debian-9-r35" \
    PATH="/opt/bitnami/nats/bin:$PATH"

RUN install_packages curl
RUN chown -R 1001:1001 /opt/bitnami/nats

EXPOSE 4222 6222 8222

COPY rootfs /
WORKDIR /opt/bitnami/nats
USER 1001
ENTRYPOINT ["/entrypoint.sh"]
