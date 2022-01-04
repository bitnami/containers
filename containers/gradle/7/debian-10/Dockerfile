FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/app" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.13-0-linux-amd64-debian-10.tar.gz && \
    echo "9552e53ccd3b0ec85a82c31c26a1462260e28b7c58770a5c53560afb02ec66d9  /tmp/bitnami/pkg/cache/java-11.0.13-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.13-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.13-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/gradle-7.3.3-0-linux-amd64-debian-10.tar.gz && \
    echo "2478613be3d4a4bbd8a80ddca930175a57b881204b7663f1adbcc08ee60cbc66  /tmp/bitnami/pkg/cache/gradle-7.3.3-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/gradle-7.3.3-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/gradle-7.3.3-0-linux-amd64-debian-10.tar.gz
RUN mkdir /app && chmod g+rwX /app

ENV BITNAMI_APP_NAME="gradle" \
    BITNAMI_IMAGE_VERSION="7.3.3-debian-10-r12" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/gradle/bin:$PATH"

WORKDIR /app
ENTRYPOINT [ "gradle" ]
CMD [ "--help" ]
