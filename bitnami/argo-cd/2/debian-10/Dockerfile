FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/argo-cd-2.0.3-0-linux-amd64-debian-10.tar.gz && \
    echo "7aabfc4eec886ef6c57535f2b284246dad795d2b45d35304b8260bf10a2eb0d4  /tmp/bitnami/pkg/cache/argo-cd-2.0.3-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/argo-cd-2.0.3-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/argo-cd-2.0.3-0-linux-amd64-debian-10.tar.gz
RUN useradd -r -u 1001 -g root argo-cd

ENV BITNAMI_APP_NAME="argo-cd" \
    BITNAMI_IMAGE_VERSION="2.0.3-debian-10-r0" \
    PATH="/opt/bitnami/argo-cd/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/argo-cd/bin/argocd" ]
