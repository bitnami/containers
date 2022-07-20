FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubeapps-apis-2.4.6-0-linux-amd64-debian-11.tar.gz && \
    echo "7784137e07c4ed70a5c3c47005954d0ca2a2be7fb710b3ce2a1fcf6c5b8d6864  /tmp/bitnami/pkg/cache/kubeapps-apis-2.4.6-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubeapps-apis-2.4.6-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubeapps-apis-2.4.6-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/kubeapps-apis/plugins /plugins && ln -s /opt/bitnami/kubeapps-apis/bin/kubeapps-apis /kubeapps-apis

ENV APP_VERSION="2.4.6" \
    BITNAMI_APP_NAME="kubeapps-apis" \
    PATH="/opt/bitnami/kubeapps-apis/bin:$PATH"

EXPOSE 50051

USER 1001
ENTRYPOINT [ "kubeapps-apis" ]
CMD [ "--help" ]
