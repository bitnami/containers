FROM bitnami/minideb as development

ARG NODE_EXPORTER_VERSION=0.15.2
ARG NODE_EXPORTER_DIR=node_exporter-$NODE_EXPORTER_VERSION.linux-amd64

RUN install_packages wget ca-certificates

RUN wget -nc https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VERSION/$NODE_EXPORTER_DIR.tar.gz && \
    tar -xzf $NODE_EXPORTER_DIR.tar.gz

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

ARG NODE_EXPORTER_VERSION=0.15.2
ARG NODE_EXPORTER_DIR=node_exporter-$NODE_EXPORTER_VERSION.linux-amd64

COPY --from=development /$NODE_EXPORTER_DIR/node_exporter /opt/bitnami/node_exporter/bin/node_exporter
COPY --from=development /$NODE_EXPORTER_DIR/LICENSE /opt/bitnami/node_exporter/LICENSE

ENV PATH="/opt/bitnami/node_exporter/bin:$PATH"

EXPOSE     9100
WORKDIR    /opt/bitnami/node_exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/node_exporter/bin/node_exporter" ]
