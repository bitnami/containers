FROM bitnami/oraclelinux-extras:7-r127 as buildenv

RUN install_packages ca-certificates glibc wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kube-state-metrics-1.4.0-1-linux-x86_64-ol-7.tar.gz && \
    echo "527ef8c4898f7a12385f06574b7189865171e815f52fc6ab18addcb0b4645c8a  /tmp/bitnami/pkg/cache/kube-state-metrics-1.4.0-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kube-state-metrics-1.4.0-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kube-state-metrics-1.4.0-1-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r127
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/kube-state-metrics /opt/bitnami/kube-state-metrics
ENV BITNAMI_APP_NAME="kube-state-metrics" \
    BITNAMI_IMAGE_VERSION="1.4.0-ol-7-r37" \
    PATH="/opt/bitnami/kube-state-metrics/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 8080 8081

WORKDIR /opt/bitnami/kube-state-metrics
USER 1001
ENTRYPOINT [ "kube-state-metrics", "--port=8080", "--telemetry-port=8081" ]
