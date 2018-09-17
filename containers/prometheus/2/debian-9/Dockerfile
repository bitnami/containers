FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/prometheus-2.4.0-0-linux-amd64-debian-9.tar.gz && \
    echo "2f1377317b74a4461b034ade848717d1aa375686359902745f263ded026978bc  /tmp/bitnami/pkg/cache/prometheus-2.4.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/prometheus-2.4.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/prometheus-2.4.0-0-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/prometheus /opt/bitnami/prometheus
ENV BITNAMI_APP_NAME="prometheus" \
    BITNAMI_IMAGE_VERSION="2.4.0-debian-9-r6" \
    PATH="/opt/bitnami/prometheus/bin:$PATH"

RUN mkdir -p /opt/bitnami/prometheus/data/ && chmod g+rwX /opt/bitnami/prometheus/data/

EXPOSE 9090

WORKDIR /opt/bitnami/prometheus
USER 1001
ENTRYPOINT [ "/opt/bitnami/prometheus/bin/prometheus" ]
CMD [ "--config.file=/opt/bitnami/prometheus/conf/prometheus.yml", "--storage.tsdb.path=/opt/bitnami/prometheus/data", "--web.console.libraries=/opt/bitnami/prometheus/conf/console_libraries", "--web.console.templates=/opt/bitnami/prometheus/conf/consoles" ]
