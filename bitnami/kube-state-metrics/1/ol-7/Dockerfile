FROM bitnami/oraclelinux-extras:7-r66 as buildenv

RUN install_packages ca-certificates glibc wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kube-state-metrics-1.3.1-0-linux-x86_64-ol-7.tar.gz && \
    echo "77d1c30e4a90aba6ed05a697d8c779f2793c3698e84f02cbd28d35417c4bfe4d  /tmp/bitnami/pkg/cache/kube-state-metrics-1.3.1-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kube-state-metrics-1.3.1-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kube-state-metrics-1.3.1-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r66
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/kube-state-metrics /opt/bitnami/kube-state-metrics
ENV BITNAMI_APP_NAME="kube-state-metrics" \
    BITNAMI_IMAGE_VERSION="1.3.1-ol-7-r40" \
    PATH="/opt/bitnami/kube-state-metrics/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 8080 8081

WORKDIR /opt/bitnami/kube-state-metrics
USER 1001
ENTRYPOINT ["kube-state-metrics","--port=8080","--telemetry-port=8081"]
