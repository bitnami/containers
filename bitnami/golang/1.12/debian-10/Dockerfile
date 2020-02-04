FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git libc6 pkg-config procps sudo unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/golang-1.12.16-0-linux-amd64-debian-10.tar.gz && \
    echo "a52ae3d2ff26f55466dfe61467c5d0bafb05f136b2a9cb8aa0c4e3e97794d137  /tmp/bitnami/pkg/cache/golang-1.12.16-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/golang-1.12.16-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/golang-1.12.16-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir -p "/go/src" "/go/bin" && chmod -R 777 "/go"

ENV BITNAMI_APP_NAME="golang" \
    BITNAMI_IMAGE_VERSION="1.12.16-debian-10-r4" \
    GOPATH="/go" \
    PATH="/go/bin:/opt/bitnami/go/bin:$PATH"

WORKDIR $GOPATH
CMD [ "bash" ]
