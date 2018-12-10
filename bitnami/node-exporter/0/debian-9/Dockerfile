FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-exporter-0.17.0-0-linux-amd64-debian-9.tar.gz && \
    echo "ade7180935090cd52ce1614e36b97e75966d8a553c4a41ecb596c9269ef50d69  /tmp/bitnami/pkg/cache/node-exporter-0.17.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-exporter-0.17.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-exporter-0.17.0-0-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/node-exporter /opt/bitnami/node-exporter
ENV BITNAMI_APP_NAME="node-exporter" \
    BITNAMI_IMAGE_VERSION="0.17.0-debian-9-r9" \
    PATH="/opt/bitnami/node-exporter/bin:$PATH"

EXPOSE 9100

WORKDIR /opt/bitnami/node-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/node-exporter/bin/node_exporter" ]
