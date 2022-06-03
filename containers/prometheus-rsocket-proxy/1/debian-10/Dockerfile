FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.333-0-linux-amd64-debian-10.tar.gz && \
    echo "4b5fa59710327cb409d6f469335a71ba1ce1ad2068e30b2aa35b9cbc101bcd6f  /tmp/bitnami/pkg/cache/java-1.8.333-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.333-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.333-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/prometheus-rsocket-proxy-1.4.0-1-linux-amd64-debian-10.tar.gz && \
    echo "783cd82236dd95a5d91650b0ad4f90442b627209bf06420abcd3664b7801ad13  /tmp/bitnami/pkg/cache/prometheus-rsocket-proxy-1.4.0-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/prometheus-rsocket-proxy-1.4.0-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/prometheus-rsocket-proxy-1.4.0-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN touch /opt/bitnami/prometheus-rsocket-proxy/prometheus-rsocket-proxy.log && chmod -R g+rwX /opt/bitnami/prometheus-rsocket-proxy

ENV APP_VERSION="1.4.0" \
    BITNAMI_APP_NAME="prometheus-rsocket-proxy" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/prometheus-rsocket-proxy
USER 1001
ENTRYPOINT [ "/opt/bitnami/java/bin/java", "-jar", "/opt/bitnami/prometheus-rsocket-proxy/prometheus-rsocket-proxy.jar" ]
