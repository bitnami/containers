FROM bitnami/oraclelinux-extras:7-r186 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-exporter-0.17.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "9a43b7aa7e8b31a1e3e0bd8e7761774ab97d277e26ff5e5976e3b893dd8247bb  /tmp/bitnami/pkg/cache/node-exporter-0.17.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-exporter-0.17.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-exporter-0.17.0-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r186
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/node-exporter /opt/bitnami/node-exporter
ENV BITNAMI_APP_NAME="node-exporter" \
    BITNAMI_IMAGE_VERSION="0.17.0-ol-7-r2" \
    PATH="/opt/bitnami/node-exporter/bin:$PATH"

EXPOSE 9100

WORKDIR /opt/bitnami/node-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/node-exporter/bin/node_exporter" ]
