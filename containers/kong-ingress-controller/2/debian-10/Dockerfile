FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wait-for-port-1.0.1-5-linux-amd64-debian-10.tar.gz && \
    echo "1e34030c18f0ec2467fa5f1b1fbad24add217f671c3a61628f7b8671391f9676  /tmp/bitnami/pkg/cache/wait-for-port-1.0.1-5-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wait-for-port-1.0.1-5-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wait-for-port-1.0.1-5-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kong-ingress-controller-2.1.1-2-linux-amd64-debian-10.tar.gz && \
    echo "2c9a7b928e41d95580c35040012b960eec78ce3518fdd5afcc14f5d4fa82598a  /tmp/bitnami/pkg/cache/kong-ingress-controller-2.1.1-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kong-ingress-controller-2.1.1-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kong-ingress-controller-2.1.1-2-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="kong-ingress-controller" \
    BITNAMI_IMAGE_VERSION="2.1.1-debian-10-r10" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/kong-ingress-controller/bin:$PATH"

USER 1001
ENTRYPOINT [ "kong-ingress-controller" ]
CMD [ "--help" ]
