FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps sudo unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cluster-autoscaler-1.17.1-0-linux-amd64-debian-10.tar.gz && \
    echo "3568df0581ea40f68b732b9906fb5f0e8962ef4bb9462ee358331212b9bd9c5f  /tmp/bitnami/pkg/cache/cluster-autoscaler-1.17.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.17.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.17.1-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN chmod -R g+rwX /opt/bitnami/cluster-autoscaler/
ENV BITNAMI_APP_NAME="cluster-autoscaler" \
    BITNAMI_IMAGE_VERSION="1.17.1-debian-10-r4" \
    PATH="/opt/bitnami/cluster-autoscaler/bin:$PATH"

WORKDIR /opt/bitnami/cluster-autoscaler
USER 1001
CMD [ "/run.sh" ]
