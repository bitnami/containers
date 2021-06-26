FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/argo-cd-2.0.4-0-linux-amd64-debian-10.tar.gz && \
    echo "df45b3e85eae0926c8ad8f917428c715d8ff86feb5107a356c535bece92e0f9d  /tmp/bitnami/pkg/cache/argo-cd-2.0.4-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/argo-cd-2.0.4-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/argo-cd-2.0.4-0-linux-amd64-debian-10.tar.gz
RUN useradd -r -u 1001 -g root argo-cd

ENV BITNAMI_APP_NAME="argo-cd" \
    BITNAMI_IMAGE_VERSION="2.0.4-debian-10-r1" \
    PATH="/opt/bitnami/argo-cd/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/argo-cd/bin/argocd" ]
