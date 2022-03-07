FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip iproute2 libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/concourse-7.6.0-8-linux-amd64-debian-10.tar.gz && \
    echo "bb422e583ae8f4f129ba5fa01186309e354c16decef193c9cdfbd8a623912022  /tmp/bitnami/pkg/cache/concourse-7.6.0-8-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/concourse-7.6.0-8-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/concourse-7.6.0-8-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN touch /.flyrc && chmod g+rwX /.flyrc

ENV BITNAMI_APP_NAME="concourse" \
    BITNAMI_IMAGE_VERSION="7.6.0-debian-10-r123" \
    PATH="/opt/bitnami/concourse/bin:$PATH"

CMD [ "/opt/bitnami/concourse/bin/concourse", "--help" ]
