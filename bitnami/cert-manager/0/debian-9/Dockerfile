FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cert-manager-0.7.1-0-linux-amd64-debian-9.tar.gz && \
    echo "1503b62084c15421db520a9f6e44da5b9d195ee4ee373c9fcbcca51cab2b67e3  /tmp/bitnami/pkg/cache/cert-manager-0.7.1-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cert-manager-0.7.1-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cert-manager-0.7.1-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="cert-manager" \
    BITNAMI_IMAGE_VERSION="0.7.1-debian-9-r2" \
    PATH="/opt/bitnami/cert-manager/bin:$PATH"

WORKDIR /opt/bitnami/cert-manager
USER 1001
ENTRYPOINT [ "/opt/bitnami/cert-manager/bin/cert-manager" ]
