FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/metallb-0.12.0-0-linux-amd64-debian-10.tar.gz && \
    echo "990ae134c1aff8dc819f79787b05b4f2f65213e339fd1b3bb6644ec8e4d5147c  /tmp/bitnami/pkg/cache/metallb-0.12.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/metallb-0.12.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/metallb-0.12.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="metallb-controller" \
    BITNAMI_IMAGE_VERSION="0.12.0-debian-10-r0" \
    PATH="/opt/bitnami/metallb/bin:$PATH"

USER 1001
ENTRYPOINT [ "controller" ]
CMD [ "--help" ]
