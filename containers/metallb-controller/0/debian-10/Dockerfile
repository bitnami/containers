FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/metallb-0.10.2-0-linux-amd64-debian-10.tar.gz && \
    echo "7668817b7736be37c65e3b44401ca323b7024159609cdfd67e8a6b0907844111  /tmp/bitnami/pkg/cache/metallb-0.10.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/metallb-0.10.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/metallb-0.10.2-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="metallb-controller" \
    BITNAMI_IMAGE_VERSION="0.10.2-debian-10-r2" \
    PATH="/opt/bitnami/metallb/bin:$PATH"

USER 1001
ENTRYPOINT [ "controller" ]
CMD [ "--help" ]
