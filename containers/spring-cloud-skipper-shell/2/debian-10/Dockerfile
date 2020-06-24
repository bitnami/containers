FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.252-3-linux-amd64-debian-10.tar.gz && \
    echo "8631fe0cc0887a566e878939cf8cd58650be5d5de23f3c6f94fffb258aadeb3a  /tmp/bitnami/pkg/cache/java-1.8.252-3-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.252-3-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.252-3-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/spring-cloud-skipper-shell-2.4.1-0-linux-amd64-debian-10.tar.gz && \
    echo "7257a337dacf5ac00aa04ea2b4a6fdf0e7a0f4bfa62444a8f336510908ddad71  /tmp/bitnami/pkg/cache/spring-cloud-skipper-shell-2.4.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/spring-cloud-skipper-shell-2.4.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/spring-cloud-skipper-shell-2.4.1-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN touch /opt/bitnami/spring-cloud-skipper-shell/spring-cloud-skipper-shell.log && chmod -R g+rwX /opt/bitnami/spring-cloud-skipper-shell

ENV BITNAMI_APP_NAME="spring-cloud-skipper-shell" \
    BITNAMI_IMAGE_VERSION="2.4.1-debian-10-r8" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/spring-cloud-skipper-shell
USER 1001
ENTRYPOINT [ "/opt/bitnami/java/bin/java", "-jar", "/opt/bitnami/spring-cloud-skipper-shell/spring-cloud-skipper-shell.jar" ]
CMD [ "--help" ]
