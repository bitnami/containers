FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gcc gcc-c++ git glibc gzip hostname libaio-devel libtool make patch pkgconfig procps-ng sudo tar unzip wget which
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/golang-1.13.7-0-linux-x86_64-ol-7.tar.gz && \
    echo "497744903c0f626abfc96ae4730f34dbd31f26c3f6b9b253bd79df649158b290  /tmp/bitnami/pkg/cache/golang-1.13.7-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/golang-1.13.7-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/golang-1.13.7-0-linux-x86_64-ol-7.tar.gz
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN mkdir -p "/go/src" "/go/bin" && chmod -R 777 "/go"

ENV BITNAMI_APP_NAME="golang" \
    BITNAMI_IMAGE_VERSION="1.13.7-ol-7-r2" \
    GOPATH="/go" \
    PATH="/go/bin:/opt/bitnami/go/bin:$PATH"

WORKDIR $GOPATH
CMD [ "bash" ]
