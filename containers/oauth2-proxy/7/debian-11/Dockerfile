FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/oauth2-proxy-7.3.0-0-linux-amd64-debian-11.tar.gz && \
    echo "10978f075fa7ab1c36f3e57dc62c73b44e285c41e7187de846502d21d6d6bd0c  /tmp/bitnami/pkg/cache/oauth2-proxy-7.3.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/oauth2-proxy-7.3.0-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/oauth2-proxy-7.3.0-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN chown -R 1001:1001 /opt/bitnami/oauth2-proxy

ENV APP_VERSION="7.3.0" \
    BITNAMI_APP_NAME="oauth2-proxy" \
    PATH="/opt/bitnami/oauth2-proxy/bin:$PATH"

EXPOSE 4180 8080

WORKDIR /opt/bitnami/oauth2-proxy
USER 1001
ENTRYPOINT [ "oauth2-proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
