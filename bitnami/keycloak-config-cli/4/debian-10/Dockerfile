FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.14-6-linux-amd64-debian-10.tar.gz && \
    echo "8e9d15dc54b3cf57e7f3b92efbb1e01ed07f002889034ec7703b62efb8265243  /tmp/bitnami/pkg/cache/java-11.0.14-6-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.14-6-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.14-6-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/keycloak-config-cli-4.7.0-2-linux-amd64-debian-10.tar.gz && \
    echo "95b761142f12a58dc405cc196191c2f7eb704e17a1968cfdd928fb6f0d545aea  /tmp/bitnami/pkg/cache/keycloak-config-cli-4.7.0-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/keycloak-config-cli-4.7.0-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/keycloak-config-cli-4.7.0-2-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/keycloak-config-cli/keycloak-config-cli.jar /opt/keycloak-config-cli.jar

ENV BITNAMI_APP_NAME="keycloak-config-cli" \
    BITNAMI_IMAGE_VERSION="4.7.0-debian-10-r4" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/keycloak-config-cli
USER 1001
ENTRYPOINT [ "java", "-jar", "./keycloak-config-cli.jar" ]
