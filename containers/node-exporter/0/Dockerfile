FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node_exporter-0.15.2-0-linux-x64-debian-8.tar.gz && \
    tar -zxf /tmp/bitnami/pkg/cache/node_exporter-0.15.2-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node_exporter-0.15.2-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/node_exporter /opt/bitnami/node_exporter
ENV BITNAMI_APP_NAME="node_exporter" \
    BITNAMI_IMAGE_VERSION="0.15.2-r6" \
    PATH="/opt/bitnami/node_exporter/bin:$PATH"

EXPOSE 9100

WORKDIR /opt/bitnami/node_exporter
USER 1001
ENTRYPOINT ["/opt/bitnami/node_exporter/bin/node_exporter"]
