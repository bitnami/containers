FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="5.3.1-debian-11-r7" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/keycloak-config-cli" \
      org.opencontainers.image.title="keycloak-config-cli" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="5.3.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.15-1-2-linux-amd64-debian-11.tar.gz && \
    echo "1a5468c7b552dfc8a33c5c9b214dbf7dd143a5f008cc3aa2e0418fab5eb16c5c  /tmp/bitnami/pkg/cache/java-11.0.15-1-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.15-1-2-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.15-1-2-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/keycloak-config-cli-5.3.1-1-linux-amd64-debian-11.tar.gz && \
    echo "8a9a1e940b419e3549af2e754f9e3fed466ca1b324a131be21db478a3a28488c  /tmp/bitnami/pkg/cache/keycloak-config-cli-5.3.1-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/keycloak-config-cli-5.3.1-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/keycloak-config-cli-5.3.1-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/keycloak-config-cli/keycloak-config-cli.jar /opt/keycloak-config-cli.jar

ENV APP_VERSION="5.3.1" \
    BITNAMI_APP_NAME="keycloak-config-cli" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/keycloak-config-cli
USER 1001
ENTRYPOINT [ "java", "-jar", "./keycloak-config-cli.jar" ]
