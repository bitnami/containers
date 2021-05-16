FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cluster-autoscaler-1.21.0-0-linux-amd64-debian-10.tar.gz && \
    echo "a284d7a87c18f3c9b15e7e3d03aff5195a077ebb9d0360c9223e2e9f0d4f4940  /tmp/bitnami/pkg/cache/cluster-autoscaler-1.21.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.21.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.21.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/cluster-autoscaler/bin/cluster-autoscaler /opt/bitnami/cluster-autoscaler/cluster-autoscaler

COPY rootfs /
RUN chmod -R g+rwX /opt/bitnami/cluster-autoscaler/
ENV BITNAMI_APP_NAME="cluster-autoscaler" \
    BITNAMI_IMAGE_VERSION="1.21.0-debian-10-r3" \
    PATH="/opt/bitnami/cluster-autoscaler/bin:$PATH"

WORKDIR /opt/bitnami/cluster-autoscaler
USER 1001
CMD [ "/run.sh" ]
