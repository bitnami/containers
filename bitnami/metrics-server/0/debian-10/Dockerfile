FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/metrics-server-0.4.4-0-linux-amd64-debian-10.tar.gz && \
    echo "bbcc0089ccde0a8d1c66126c625956b8e8888680d77d0427f81e10a1130e3788  /tmp/bitnami/pkg/cache/metrics-server-0.4.4-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/metrics-server-0.4.4-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/metrics-server-0.4.4-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

RUN chown -R 1001:root /opt/bitnami/metrics-server && chmod -R g+rwX /opt/bitnami/metrics-server
ENV BITNAMI_APP_NAME="metrics-server" \
    BITNAMI_IMAGE_VERSION="0.4.4-debian-10-r14" \
    PATH="/opt/bitnami/metrics-server/bin:$PATH"

EXPOSE 8443

WORKDIR /opt/bitnami/metrics-server
USER 1001
ENTRYPOINT [ "metrics-server", "--secure-port=8443", "--cert-dir=/opt/bitnami/metrics-server/certificates" ]
