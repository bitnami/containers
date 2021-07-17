FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip iproute2 libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/concourse-7.3.2-0-linux-amd64-debian-10.tar.gz && \
    echo "1677702817f133bdb3067ff361cf395ce90fc4eb10f89b43606714247dd8b837  /tmp/bitnami/pkg/cache/concourse-7.3.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/concourse-7.3.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/concourse-7.3.2-0-linux-amd64-debian-10.tar.gz
RUN touch /.flyrc && chmod g+rwX /.flyrc

ENV BITNAMI_APP_NAME="concourse" \
    BITNAMI_IMAGE_VERSION="7.3.2-debian-10-r24" \
    PATH="/opt/bitnami/concourse/bin:$PATH"

CMD [ "/opt/bitnami/concourse/bin/concourse", "--help" ]
