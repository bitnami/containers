FROM bitnami/oraclelinux-extras:7-r472
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nats-2.0.4-1-linux-x86_64-ol-7.tar.gz && \
    echo "47e83794ca4b223295566c386567d3f0416fee4396db0fb68c3100677cc4cfde  /tmp/bitnami/pkg/cache/nats-2.0.4-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nats-2.0.4-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nats-2.0.4-1-linux-x86_64-ol-7.tar.gz

COPY rootfs /
RUN chown -R 1001:root /opt/bitnami/nats && chmod g+rwX /opt/bitnami/nats
ENV BITNAMI_APP_NAME="nats" \
    BITNAMI_IMAGE_VERSION="2.0.4-ol-7-r40" \
    PATH="/opt/bitnami/nats/bin:$PATH"

EXPOSE 4222 6222 8222

WORKDIR /opt/bitnami/nats
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
