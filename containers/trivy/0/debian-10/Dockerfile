FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/trivy-0.20.2-1-linux-amd64-debian-10.tar.gz && \
    echo "bd3731a3277d79ec33ca8397c792b1817ba257ca81f62a9c30d15ce0e1dc40a8  /tmp/bitnami/pkg/cache/trivy-0.20.2-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/trivy-0.20.2-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/trivy-0.20.2-1-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.cache && chmod g+rwX /.cache

ENV BITNAMI_APP_NAME="trivy" \
    BITNAMI_IMAGE_VERSION="0.20.2-debian-10-r12" \
    PATH="/opt/bitnami/trivy/bin:$PATH"

USER 1001
ENTRYPOINT [ "trivy" ]
CMD [ "--help" ]
