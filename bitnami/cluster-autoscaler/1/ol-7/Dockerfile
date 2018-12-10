FROM bitnami/oraclelinux-extras:7-r193 as buildenv

RUN install_packages ca-certificates glibc wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cluster-autoscaler-1.13.1-0-linux-x86_64-ol-7.tar.gz && \
    echo "d2ba3deafab4c5d0ddaac4705ea1d1b7761f6889e84d3646e73e2d02eae6084d  /tmp/bitnami/pkg/cache/cluster-autoscaler-1.13.1-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.13.1-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.13.1-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r193
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/cluster-autoscaler /opt/bitnami/cluster-autoscaler
ENV BITNAMI_APP_NAME="cluster-autoscaler" \
    BITNAMI_IMAGE_VERSION="1.13.1-ol-7-r0" \
    PATH="/opt/bitnami/cluster-autoscaler/bin:$PATH"

RUN install_packages ca-certificates
RUN chmod -R g+rwX /opt/bitnami/cluster-autoscaler/

COPY rootfs /
WORKDIR /opt/bitnami/cluster-autoscaler
USER 1001
CMD [ "/run.sh" ]
