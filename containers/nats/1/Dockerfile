FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nats-1.1.0-0-linux-x64-debian-8.tar.gz && \
    echo "bb1803e20a9f11482ccb49e14f8e2d1884505d8a67f5ff0901c32ae5a59f0cba  /tmp/bitnami/pkg/cache/nats-1.1.0-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nats-1.1.0-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nats-1.1.0-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/nats /opt/bitnami/nats
ENV BITNAMI_APP_NAME="nats" \
    BITNAMI_IMAGE_VERSION="1.1.0-r1" \
    PATH="/opt/bitnami/nats/bin:$PATH"

RUN install_packages curl

EXPOSE 4222 6222 8222

WORKDIR /opt/bitnami/nats
USER 1001
CMD ["gnatsd","-c","/opt/bitnami/nats/conf/gnatsd.conf"]
