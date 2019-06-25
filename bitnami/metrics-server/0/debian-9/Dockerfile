FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/metrics-server-0.3.3-0-linux-amd64-debian-9.tar.gz && \
    echo "98ff68f71b60976dd2c1527bf253034d4ebc4d6bd164198805ffe03ec5303394  /tmp/bitnami/pkg/cache/metrics-server-0.3.3-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/metrics-server-0.3.3-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/metrics-server-0.3.3-0-linux-amd64-debian-9.tar.gz

RUN chown -R 1001:root /opt/bitnami/metrics-server && chmod -R g+rwX /opt/bitnami/metrics-server
ENV BITNAMI_APP_NAME="metrics-server" \
    BITNAMI_IMAGE_VERSION="0.3.3-debian-9-r45" \
    PATH="/opt/bitnami/metrics-server/bin:$PATH"

EXPOSE 8443

WORKDIR /opt/bitnami/metrics-server
USER 1001
ENTRYPOINT [ "metrics-server", "--secure-port=8443", "--cert-dir=/opt/bitnami/metrics-server/certificates" ]
