FROM bitnami/minideb as development

ARG ELASTICSEARCH_EXPORTER_VERSION=1.0.2
ARG ELASTICSEARCH_EXPORTER_DIR=elasticsearch_exporter-$ELASTICSEARCH_EXPORTER_VERSION.linux-amd64

RUN install_packages wget ca-certificates
RUN wget -nc https://github.com/justwatchcom/elasticsearch_exporter/releases/download/v$ELASTICSEARCH_EXPORTER_VERSION/$ELASTICSEARCH_EXPORTER_DIR.tar.gz && \
    tar -xzf $ELASTICSEARCH_EXPORTER_DIR.tar.gz

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

ARG ELASTICSEARCH_EXPORTER_VERSION=1.0.2
ARG ELASTICSEARCH_EXPORTER_DIR=elasticsearch_exporter-$ELASTICSEARCH_EXPORTER_VERSION.linux-amd64

COPY --from=development /$ELASTICSEARCH_EXPORTER_DIR/elasticsearch_exporter /opt/bitnami/elasticsearch_exporter/bin/elasticsearch_exporter
COPY --from=development /$ELASTICSEARCH_EXPORTER_DIR/LICENSE /opt/bitnami/elasticsearch_exporter/LICENSE

ENV PATH="/opt/bitnami/elasticsearch_exporter/bin:$PATH"

EXPOSE     9108
WORKDIR    /opt/bitnami/elasticsearch_exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/elasticsearch_exporter/bin/elasticsearch_exporter" ]
