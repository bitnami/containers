FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubeapps-apis-2.4.2-1-linux-amd64-debian-10.tar.gz && \
    echo "6d5e6ab483b1957bad77368b431334f8a9ba3fa66958979ed08f28b44db5c82f  /tmp/bitnami/pkg/cache/kubeapps-apis-2.4.2-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubeapps-apis-2.4.2-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubeapps-apis-2.4.2-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/kubeapps-apis/plugins /plugins && ln -s /opt/bitnami/kubeapps-apis/bin/kubeapps-apis /kubeapps-apis

ENV BITNAMI_APP_NAME="kubeapps-apis" \
    BITNAMI_IMAGE_VERSION="2.4.2-debian-10-r48" \
    PATH="/opt/bitnami/kubeapps-apis/bin:$PATH"

EXPOSE 50051

USER 1001
ENTRYPOINT [ "kubeapps-apis" ]
CMD [ "--help" ]
