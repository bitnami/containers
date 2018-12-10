FROM bitnami/oraclelinux-extras:7-r193 as buildenv

RUN install_packages ca-certificates glibc wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kube-state-metrics-1.4.0-20-linux-x86_64-ol-7.tar.gz && \
    echo "2d3cb574538cbaaddcccf5ea8df7421a7087d73be4d4da8329ce66fade7452bb  /tmp/bitnami/pkg/cache/kube-state-metrics-1.4.0-20-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kube-state-metrics-1.4.0-20-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kube-state-metrics-1.4.0-20-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r193
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/kube-state-metrics /opt/bitnami/kube-state-metrics
ENV BITNAMI_APP_NAME="kube-state-metrics" \
    BITNAMI_IMAGE_VERSION="1.4.0-ol-7-r101" \
    PATH="/opt/bitnami/kube-state-metrics/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 8080 8081

WORKDIR /opt/bitnami/kube-state-metrics
USER 1001
ENTRYPOINT [ "kube-state-metrics", "--port=8080", "--telemetry-port=8081" ]
