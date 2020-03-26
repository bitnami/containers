FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git libc6 pkg-config procps sudo unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/golang-1.13.9-0-linux-amd64-debian-10.tar.gz && \
    echo "29b1363e4c463f9b6801979e100e13580b6e4b82a3b10cf3825664a420f215ff  /tmp/bitnami/pkg/cache/golang-1.13.9-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/golang-1.13.9-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/golang-1.13.9-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir -p "/go/src" "/go/bin" && chmod -R 777 "/go"

ENV BITNAMI_APP_NAME="golang" \
    BITNAMI_IMAGE_VERSION="1.13.9-debian-10-r1" \
    GOPATH="/go" \
    PATH="/go/bin:/opt/bitnami/go/bin:$PATH"

WORKDIR $GOPATH
CMD [ "bash" ]
