FROM bitnami/minideb as development

ARG PUSHGATEWAY_VERSION=0.4.0
ARG PUSHGATEWAY_DIR=pushgateway-$PUSHGATEWAY_VERSION.linux-amd64

RUN install_packages wget ca-certificates

RUN wget -nc https://github.com/prometheus/pushgateway/releases/download/v$PUSHGATEWAY_VERSION/$PUSHGATEWAY_DIR.tar.gz && \
    tar -xzf $PUSHGATEWAY_DIR.tar.gz

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

ARG PUSHGATEWAY_VERSION=0.4.0
ARG PUSHGATEWAY_DIR=pushgateway-$PUSHGATEWAY_VERSION.linux-amd64

COPY --from=development /$PUSHGATEWAY_DIR/pushgateway /opt/bitnami/pushgateway/bin/pushgateway
COPY --from=development /$PUSHGATEWAY_DIR/LICENSE /opt/bitnami/pushgateway/LICENSE

ENV PATH="/opt/bitnami/pushgateway/bin:$PATH"

EXPOSE     9091
USER 1001
WORKDIR    /opt/bitnami/pushgateway
ENTRYPOINT [ "/opt/bitnami/pushgateway/bin/pushgateway" ]
