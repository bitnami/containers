FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kube-state-metrics-1.3.1-0-linux-x64-debian-8.tar.gz && \
    echo "b2d101c852fd4695f96dcffcd83b3aa912a67700932b2d90186be28b94cbbbe6  /tmp/bitnami/pkg/cache/kube-state-metrics-1.3.1-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kube-state-metrics-1.3.1-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kube-state-metrics-1.3.1-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/kube-state-metrics /opt/bitnami/kube-state-metrics
ENV BITNAMI_APP_NAME="kube-state-metrics" \
    BITNAMI_IMAGE_VERSION="1.3.1-debian-8-r45" \
    PATH="/opt/bitnami/kube-state-metrics/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 8080 8081

WORKDIR /opt/bitnami/kube-state-metrics
USER 1001
ENTRYPOINT ["kube-state-metrics","--port=8080","--telemetry-port=8081"]
