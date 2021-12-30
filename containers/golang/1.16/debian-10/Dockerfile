FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git gzip libc6 pkg-config procps tar unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/golang-1.16.12-0-linux-amd64-debian-10.tar.gz && \
    echo "422687ad82c0315df0ec623d37c86eaa366086a61c6ca27d632eba1ac5d599df  /tmp/bitnami/pkg/cache/golang-1.16.12-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/golang-1.16.12-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/golang-1.16.12-0-linux-amd64-debian-10.tar.gz
RUN mkdir -p "/go/src" "/go/bin" && chmod -R 777 "/go"

ENV BITNAMI_APP_NAME="golang" \
    BITNAMI_IMAGE_VERSION="1.16.12-debian-10-r21" \
    GOPATH="/go" \
    PATH="/go/bin:/opt/bitnami/go/bin:$PATH"

WORKDIR $GOPATH
CMD [ "bash" ]
