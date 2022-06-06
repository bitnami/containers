FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/trivy-0.28.1-0-linux-amd64-debian-11.tar.gz && \
    echo "57b46d505b560e62aba2c128e0dab3e9ab0bec870a6c5f9019a81cefa968d940  /tmp/bitnami/pkg/cache/trivy-0.28.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/trivy-0.28.1-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/trivy-0.28.1-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.cache && chmod g+rwX /.cache

ENV APP_VERSION="0.28.1" \
    BITNAMI_APP_NAME="trivy" \
    PATH="/opt/bitnami/trivy/bin:$PATH"

USER 1001
ENTRYPOINT [ "trivy" ]
CMD [ "--help" ]
