FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/acmesolver-0.10.1-0-linux-amd64-debian-9.tar.gz && \
    echo "34399fa8e92d75366fa214079cd814e9597e9b2cea3d4af895dda8a96de8083e  /tmp/bitnami/pkg/cache/acmesolver-0.10.1-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/acmesolver-0.10.1-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/acmesolver-0.10.1-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="acmesolver" \
    BITNAMI_IMAGE_VERSION="0.10.1-debian-9-r1" \
    PATH="/opt/bitnami/acmesolver/bin:$PATH"

WORKDIR /opt/bitnami/acmesolver
USER 1001
ENTRYPOINT [ "/opt/bitnami/acmesolver/bin/acmesolver" ]
