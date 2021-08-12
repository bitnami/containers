FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip iproute2 libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/concourse-7.4.0-0-linux-amd64-debian-10.tar.gz && \
    echo "1ac921dc4198c2cb7b75efd120a775daf26e677537e0add3f701004f96d457fc  /tmp/bitnami/pkg/cache/concourse-7.4.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/concourse-7.4.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/concourse-7.4.0-0-linux-amd64-debian-10.tar.gz
RUN touch /.flyrc && chmod g+rwX /.flyrc

ENV BITNAMI_APP_NAME="concourse" \
    BITNAMI_IMAGE_VERSION="7.4.0-debian-10-r13" \
    PATH="/opt/bitnami/concourse/bin:$PATH"

CMD [ "/opt/bitnami/concourse/bin/concourse", "--help" ]
