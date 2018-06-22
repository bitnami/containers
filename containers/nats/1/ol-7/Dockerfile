FROM bitnami/oraclelinux-extras:7-r14 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nats-1.1.0-4-linux-x86_64-ol-7.tar.gz && \
    echo "2dc80823c0ec13c411a8a53073ff6370c3840fbcf94cb8b97ed3dc6e996d6889  /tmp/bitnami/pkg/cache/nats-1.1.0-4-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nats-1.1.0-4-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nats-1.1.0-4-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r14
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/nats /opt/bitnami/nats
ENV BITNAMI_APP_NAME="nats" \
    BITNAMI_IMAGE_VERSION="1.1.0-ol-7-r2" \
    PATH="/opt/bitnami/nats/bin:$PATH"

RUN install_packages curl
RUN chown -R 1001:1001 /opt/bitnami/nats

EXPOSE 4222 6222 8222

COPY rootfs /
WORKDIR /opt/bitnami/nats
USER 1001
ENTRYPOINT ["/entrypoint.sh"]
