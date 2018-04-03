FROM bitnami/minideb as development

ARG ALERTMANAGER_VERSION=0.14.0
ARG ALERTMANAGER_DIR=alertmanager-$ALERTMANAGER_VERSION.linux-amd64

RUN install_packages wget ca-certificates

RUN wget -nc https://github.com/prometheus/alertmanager/releases/download/v$ALERTMANAGER_VERSION/$ALERTMANAGER_DIR.tar.gz && \
    tar -xzf $ALERTMANAGER_DIR.tar.gz

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

ARG ALERTMANAGER_VERSION=0.14.0
ARG ALERTMANAGER_DIR=alertmanager-$ALERTMANAGER_VERSION.linux-amd64

COPY --from=development /$ALERTMANAGER_DIR/alertmanager /$ALERTMANAGER_DIR/amtool /opt/bitnami/alertmanager/bin/
COPY --from=development /$ALERTMANAGER_DIR/simple.yml /opt/bitnami/alertmanager/conf/config.yml
COPY --from=development /$ALERTMANAGER_DIR/LICENSE /opt/bitnami/alertmanager/LICENSE

RUN mkdir -p /opt/bitnami/alertmanager/data/ && chmod -R g+rwX /opt/bitnami/alertmanager/data/

ENV PATH="/opt/bitnami/alertmanager/bin:$PATH"

USER       1001
EXPOSE     9093
WORKDIR    /opt/bitnami/alertmanager/data
ENTRYPOINT [ "/opt/bitnami/alertmanager/bin/alertmanager" ]
CMD        [ "--config.file=/opt/bitnami/alertmanager/conf/config.yml", \
             "--storage.path=/opt/bitnami/alertmanager/data" ]
