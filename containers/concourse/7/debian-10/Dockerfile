FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip iproute2 libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/concourse-7.7.0-0-linux-amd64-debian-10.tar.gz && \
    echo "43b363f3a22f4005874fb88932d29d63952ef78359bcbe77cd1b8a8b010744d6  /tmp/bitnami/pkg/cache/concourse-7.7.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/concourse-7.7.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/concourse-7.7.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN touch /.flyrc && chmod g+rwX /.flyrc

ENV APP_VERSION="7.7.0" \
    BITNAMI_APP_NAME="concourse" \
    BITNAMI_IMAGE_VERSION="7.7.0-debian-10-r13" \
    PATH="/opt/bitnami/concourse/bin:$PATH"

CMD [ "/opt/bitnami/concourse/bin/concourse", "--help" ]
