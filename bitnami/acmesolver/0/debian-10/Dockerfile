FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps sudo unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/acmesolver-0.13.0-0-linux-amd64-debian-10.tar.gz && \
    echo "658a2580bdb4ce2e3af389993d7cd150e6f3eea241cc2ef7e19667293a43689f  /tmp/bitnami/pkg/cache/acmesolver-0.13.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/acmesolver-0.13.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/acmesolver-0.13.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="acmesolver" \
    BITNAMI_IMAGE_VERSION="0.13.0-debian-10-r9" \
    PATH="/opt/bitnami/acmesolver/bin:$PATH"

WORKDIR /opt/bitnami/acmesolver
USER 1001
ENTRYPOINT [ "/opt/bitnami/acmesolver/bin/acmesolver" ]
