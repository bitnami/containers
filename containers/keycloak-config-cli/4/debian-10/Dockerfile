FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.14-7-linux-amd64-debian-10.tar.gz && \
    echo "900545c4f346a0ece8abf2caf64fd9d4ab7514967d4614d716bf7362b24f828b  /tmp/bitnami/pkg/cache/java-11.0.14-7-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.14-7-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.14-7-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/keycloak-config-cli-4.7.0-3-linux-amd64-debian-10.tar.gz && \
    echo "ff6cd1095c6ea887f89cd26122579213a8be3026cd04bff3ae92878c77117956  /tmp/bitnami/pkg/cache/keycloak-config-cli-4.7.0-3-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/keycloak-config-cli-4.7.0-3-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/keycloak-config-cli-4.7.0-3-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/keycloak-config-cli/keycloak-config-cli.jar /opt/keycloak-config-cli.jar

ENV BITNAMI_APP_NAME="keycloak-config-cli" \
    BITNAMI_IMAGE_VERSION="4.7.0-debian-10-r15" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/keycloak-config-cli
USER 1001
ENTRYPOINT [ "java", "-jar", "./keycloak-config-cli.jar" ]
