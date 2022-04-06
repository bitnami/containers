FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/trivy-0.25.3-0-linux-amd64-debian-10.tar.gz && \
    echo "6194caf7f02ddf9580032cbab8e01b598df292d708a8669da4015b7d409e8c4f  /tmp/bitnami/pkg/cache/trivy-0.25.3-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/trivy-0.25.3-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/trivy-0.25.3-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.cache && chmod g+rwX /.cache

ENV APP_VERSION="0.25.3" \
    BITNAMI_APP_NAME="trivy" \
    BITNAMI_IMAGE_VERSION="0.25.3-debian-10-r0" \
    PATH="/opt/bitnami/trivy/bin:$PATH"

USER 1001
ENTRYPOINT [ "trivy" ]
CMD [ "--help" ]
