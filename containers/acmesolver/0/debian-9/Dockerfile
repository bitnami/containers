FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/acmesolver-0.9.0-0-linux-amd64-debian-9.tar.gz && \
    echo "bd087f092db696d39f0a597492c5432f7c7fa75f898b1ce61e34277f12b1cfad  /tmp/bitnami/pkg/cache/acmesolver-0.9.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/acmesolver-0.9.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/acmesolver-0.9.0-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="acmesolver" \
    BITNAMI_IMAGE_VERSION="0.9.0-debian-9-r8" \
    PATH="/opt/bitnami/acmesolver/bin:$PATH"

WORKDIR /opt/bitnami/acmesolver
USER 1001
ENTRYPOINT [ "/opt/bitnami/acmesolver/bin/acmesolver" ]
