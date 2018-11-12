FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/prometheus-2.5.0-0-linux-amd64-debian-9.tar.gz && \
    echo "9d16b92da3da16304462945dd685989101bf66655ffb152ca7233aa5f00f71cd  /tmp/bitnami/pkg/cache/prometheus-2.5.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/prometheus-2.5.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/prometheus-2.5.0-0-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/prometheus /opt/bitnami/prometheus
ENV BITNAMI_APP_NAME="prometheus" \
    BITNAMI_IMAGE_VERSION="2.5.0-debian-9-r5" \
    PATH="/opt/bitnami/prometheus/bin:$PATH"

RUN install_packages ca-certificates
RUN mkdir -p /opt/bitnami/prometheus/data/ && chmod g+rwX /opt/bitnami/prometheus/data/

EXPOSE 9090

WORKDIR /opt/bitnami/prometheus
USER 1001
ENTRYPOINT [ "/opt/bitnami/prometheus/bin/prometheus" ]
CMD [ "--config.file=/opt/bitnami/prometheus/conf/prometheus.yml", "--storage.tsdb.path=/opt/bitnami/prometheus/data", "--web.console.libraries=/opt/bitnami/prometheus/conf/console_libraries", "--web.console.templates=/opt/bitnami/prometheus/conf/consoles" ]
