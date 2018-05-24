FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cluster-autoscaler-1.2.1-0-linux-x64-debian-8.tar.gz && \
    echo "36f31a23cea54555d6e95b2591d7cfc2d60494874a4ba6a281fa9af45bf2daa0  /tmp/bitnami/pkg/cache/cluster-autoscaler-1.2.1-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.2.1-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.2.1-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/cluster-autoscaler /opt/bitnami/cluster-autoscaler
ENV BITNAMI_APP_NAME="cluster-autoscaler" \
    BITNAMI_IMAGE_VERSION="1.2.1-r5" \
    PATH="/opt/bitnami/cluster-autoscaler/bin:$PATH"

RUN install_packages ca-certificates
RUN chmod -R g+rwX /opt/bitnami/cluster-autoscaler/

COPY rootfs /
WORKDIR /opt/bitnami/cluster-autoscaler
USER 1001
CMD ["/run.sh"]
