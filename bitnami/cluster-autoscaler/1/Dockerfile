FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cluster-autoscaler-1.3.1-0-linux-x64-debian-8.tar.gz && \
    echo "19db67a27ac804cd95a95ce09a9451eb083e64d840323967489d72c0c7f7a679  /tmp/bitnami/pkg/cache/cluster-autoscaler-1.3.1-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.3.1-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.3.1-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/cluster-autoscaler /opt/bitnami/cluster-autoscaler
ENV BITNAMI_APP_NAME="cluster-autoscaler" \
    BITNAMI_IMAGE_VERSION="1.3.1-debian-8-r3" \
    PATH="/opt/bitnami/cluster-autoscaler/bin:$PATH"

RUN install_packages ca-certificates
RUN chmod -R g+rwX /opt/bitnami/cluster-autoscaler/

COPY rootfs /
WORKDIR /opt/bitnami/cluster-autoscaler
USER 1001
CMD ["/run.sh"]
