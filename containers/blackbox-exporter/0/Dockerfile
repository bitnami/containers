FROM bitnami/minideb as development

ARG BLACKBOX_EXPORTER_VERSION=0.12.0
ARG BLACKBOX_EXPORTER_DIR=blackbox_exporter-$BLACKBOX_EXPORTER_VERSION.linux-amd64

RUN install_packages wget ca-certificates

RUN wget -nc https://github.com/prometheus/blackbox_exporter/releases/download/v$BLACKBOX_EXPORTER_VERSION/$BLACKBOX_EXPORTER_DIR.tar.gz && \
    tar -xzf $BLACKBOX_EXPORTER_DIR.tar.gz

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

ARG BLACKBOX_EXPORTER_VERSION=0.12.0
ARG BLACKBOX_EXPORTER_DIR=blackbox_exporter-$BLACKBOX_EXPORTER_VERSION.linux-amd64

COPY --from=development /$BLACKBOX_EXPORTER_DIR/blackbox_exporter /opt/bitnami/blackbox_exporter/bin/blackbox_exporter
COPY --from=development /$BLACKBOX_EXPORTER_DIR/blackbox.yml /opt/bitnami/blackbox_exporter/conf/config.yml
COPY --from=development /$BLACKBOX_EXPORTER_DIR/LICENSE /opt/bitnami/blackbox_exporter/LICENSE

ENV PATH="/opt/bitnami/blackbox_exporter/bin:$PATH"

EXPOSE     9115
WORKDIR    /opt/bitnami/blackbox_exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/blackbox_exporter/bin/blackbox_exporter" ]
CMD         [ "--config.file=/opt/bitnami/blackbox_exporter/conf/config.yml" ]
