FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.15-0-linux-amd64-debian-10.tar.gz && \
    echo "255bc547614ce8052f416a74c58cfb916f724876315f15b816e0eb98b2bded35  /tmp/bitnami/pkg/cache/java-11.0.15-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.15-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.15-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/keycloak-config-cli-5.2.0-0-linux-amd64-debian-10.tar.gz && \
    echo "fc9d21528ef139c09e09866ed443d2a449dcf572652b26e9fde7ceadcfeb875f  /tmp/bitnami/pkg/cache/keycloak-config-cli-5.2.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/keycloak-config-cli-5.2.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/keycloak-config-cli-5.2.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/keycloak-config-cli/keycloak-config-cli.jar /opt/keycloak-config-cli.jar

ENV APP_VERSION="5.2.0" \
    BITNAMI_APP_NAME="keycloak-config-cli" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/keycloak-config-cli
USER 1001
ENTRYPOINT [ "java", "-jar", "./keycloak-config-cli.jar" ]
