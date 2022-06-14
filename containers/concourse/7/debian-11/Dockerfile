FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip iproute2 libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/concourse-7.8.1-0-linux-amd64-debian-11.tar.gz && \
    echo "28f9d5506ca98b3acd35e82fd905c900105343aaba7acb5638a682f904801124  /tmp/bitnami/pkg/cache/concourse-7.8.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/concourse-7.8.1-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/concourse-7.8.1-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN touch /.flyrc && chmod g+rwX /.flyrc

ENV APP_VERSION="7.8.1" \
    BITNAMI_APP_NAME="concourse" \
    PATH="/opt/bitnami/concourse/bin:$PATH"

CMD [ "/opt/bitnami/concourse/bin/concourse", "--help" ]
