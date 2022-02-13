FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cluster-autoscaler-1.23.0-4-linux-amd64-debian-10.tar.gz && \
    echo "9e56280a41476bdd00385453c88cce2df9f18ec03d3664232ef317aaecf99f60  /tmp/bitnami/pkg/cache/cluster-autoscaler-1.23.0-4-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.23.0-4-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.23.0-4-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/cluster-autoscaler/bin/cluster-autoscaler /opt/bitnami/cluster-autoscaler/cluster-autoscaler

COPY rootfs /
RUN chmod -R g+rwX /opt/bitnami/cluster-autoscaler/
ENV BITNAMI_APP_NAME="cluster-autoscaler" \
    BITNAMI_IMAGE_VERSION="1.23.0-debian-10-r38" \
    PATH="/opt/bitnami/cluster-autoscaler/bin:$PATH"

WORKDIR /opt/bitnami/cluster-autoscaler
USER 1001
CMD [ "/run.sh" ]
