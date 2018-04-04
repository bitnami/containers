FROM bitnami/minideb as development

ARG GRAFANA_VERSION=5.0.3
ARG GRAFANA_DIR=grafana-$GRAFANA_VERSION

RUN install_packages wget ca-certificates curl

RUN wget -nc https://s3-us-west-2.amazonaws.com/grafana-releases/release/$GRAFANA_DIR.linux-x64.tar.gz && \
    tar -xzf $GRAFANA_DIR.linux-x64.tar.gz


RUN mkdir /$GRAFANA_DIR/data /$GRAFANA_DIR/logs
RUN chmod g+w /$GRAFANA_DIR/data /$GRAFANA_DIR/logs

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

ARG GRAFANA_VERSION=5.0.3
ARG GRAFANA_DIR=grafana-$GRAFANA_VERSION

COPY --from=development /$GRAFANA_DIR/ /opt/bitnami/grafana/
COPY --from=development /$GRAFANA_DIR/conf/sample.ini /opt/bitnami/grafana/conf/grafana.ini

COPY rootfs/ /

ENV PATH="/opt/bitnami/grafana/bin:$PATH"

EXPOSE     9115
WORKDIR    /opt/bitnami/grafana
USER 1001
ENTRYPOINT [ "/run.sh" ]
