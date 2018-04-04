FROM bitnami/minideb:jessie as development

ARG PROMETHEUS_VERSION=2.2.1
ARG PROMETHEUS_DIR=prometheus-$PROMETHEUS_VERSION.linux-amd64

RUN install_packages wget ca-certificates

RUN wget -nc https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/$PROMETHEUS_DIR.tar.gz && \
    tar -xzf $PROMETHEUS_DIR.tar.gz

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

ARG PROMETHEUS_VERSION=2.2.1
ARG PROMETHEUS_DIR=prometheus-$PROMETHEUS_VERSION.linux-amd64

COPY --from=development /$PROMETHEUS_DIR/prometheus /$PROMETHEUS_DIR/promtool /opt/bitnami/prometheus/bin/
COPY --from=development /$PROMETHEUS_DIR/prometheus.yml /$PROMETHEUS_DIR/console_libraries /$PROMETHEUS_DIR/consoles /opt/bitnami/prometheus/conf/
COPY --from=development /$PROMETHEUS_DIR/LICENSE /opt/bitnami/prometheus/LICENSE

RUN mkdir -p /opt/bitnami/prometheus/data/ && chmod g+rwX /opt/bitnami/prometheus/data/

ENV PATH="/opt/bitnami/prometheus/bin:$PATH"

USER       1001
EXPOSE     9090
WORKDIR    /opt/bitnami/prometheus/data
ENTRYPOINT [ "/opt/bitnami/prometheus/bin/prometheus" ]
CMD        [ "--config.file=/opt/bitnami/prometheus/conf/prometheus.yml", \
             "--storage.tsdb.path=/opt/bitnami/prometheus/data", \
             "--web.console.libraries=/opt/bitnami/prometheus/conf/console_libraries", \
             "--web.console.templates=/opt/bitnami/prometheus/conf/consoles" ]
