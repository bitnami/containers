FROM bitnami/oraclelinux-extras:7-r44 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nats-1.2.0-4-linux-x86_64-ol-7.tar.gz && \
    echo "89170ae59a7ebd5c43f13f9447f0a50c984d9a0e7d4f956f72d1d26b22148ea7  /tmp/bitnami/pkg/cache/nats-1.2.0-4-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nats-1.2.0-4-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nats-1.2.0-4-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r44
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/nats /opt/bitnami/nats
ENV BITNAMI_APP_NAME="nats" \
    BITNAMI_IMAGE_VERSION="1.2.0-ol-7-r19" \
    PATH="/opt/bitnami/nats/bin:$PATH"

RUN install_packages curl
RUN chown -R 1001:1001 /opt/bitnami/nats

EXPOSE 4222 6222 8222

COPY rootfs /
WORKDIR /opt/bitnami/nats
USER 1001
ENTRYPOINT ["/entrypoint.sh"]
