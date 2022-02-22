FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubeapps-apis-2.4.3-5-linux-amd64-debian-10.tar.gz && \
    echo "51da161e4806964da86e435954dfbf645e6ad15a23cb143b465daab233d5c809  /tmp/bitnami/pkg/cache/kubeapps-apis-2.4.3-5-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubeapps-apis-2.4.3-5-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubeapps-apis-2.4.3-5-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/kubeapps-apis/plugins /plugins && ln -s /opt/bitnami/kubeapps-apis/bin/kubeapps-apis /kubeapps-apis

ENV BITNAMI_APP_NAME="kubeapps-apis" \
    BITNAMI_IMAGE_VERSION="2.4.3-debian-10-r12" \
    PATH="/opt/bitnami/kubeapps-apis/bin:$PATH"

EXPOSE 50051

USER 1001
ENTRYPOINT [ "kubeapps-apis" ]
CMD [ "--help" ]
