FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/acmesolver-1.6.1-3-linux-amd64-debian-10.tar.gz && \
    echo "6d868c4bd8c37b113b220e83eff4dfbc1f25fa189504ac4859a0b99b19ee7146  /tmp/bitnami/pkg/cache/acmesolver-1.6.1-3-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/acmesolver-1.6.1-3-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/acmesolver-1.6.1-3-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="acmesolver" \
    BITNAMI_IMAGE_VERSION="1.6.1-debian-10-r81" \
    PATH="/opt/bitnami/acmesolver/bin:$PATH"

WORKDIR /opt/bitnami/acmesolver
USER 1001
ENTRYPOINT [ "/opt/bitnami/acmesolver/bin/acmesolver" ]
