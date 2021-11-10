FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 libssl1.1 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubeapps-pinniped-proxy-2.4.1-1-linux-amd64-debian-10.tar.gz && \
    echo "e9e545638919765ce5d79e0d0278bc203a79c2ccb81b095fbc5a624e97848bc7  /tmp/bitnami/pkg/cache/kubeapps-pinniped-proxy-2.4.1-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubeapps-pinniped-proxy-2.4.1-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubeapps-pinniped-proxy-2.4.1-1-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="kubeapps-pinniped-proxy" \
    BITNAMI_IMAGE_VERSION="2.4.1-debian-10-r34" \
    PATH="/opt/bitnami/kubeapps-pinniped-proxy/bin:$PATH"

USER 1001
ENTRYPOINT [ "pinniped-proxy" ]
CMD [ "--help" ]
