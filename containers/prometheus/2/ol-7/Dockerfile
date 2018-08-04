FROM bitnami/oraclelinux-extras:7-r58 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/prometheus-2.3.2-0-linux-x86_64-ol-7.tar.gz && \
    echo "dbade1d97016e8dfe5f5ed616428aeb5fd824ac80faa48f2dd982683c49330d0  /tmp/bitnami/pkg/cache/prometheus-2.3.2-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/prometheus-2.3.2-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/prometheus-2.3.2-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r58
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/prometheus /opt/bitnami/prometheus
ENV BITNAMI_APP_NAME="prometheus" \
    BITNAMI_IMAGE_VERSION="2.3.2-ol-7-r19" \
    PATH="/opt/bitnami/prometheus/bin:$PATH"

RUN mkdir -p /opt/bitnami/prometheus/data/ && chmod g+rwX /opt/bitnami/prometheus/data/

EXPOSE 9090

WORKDIR /opt/bitnami/prometheus
USER 1001
ENTRYPOINT ["/opt/bitnami/prometheus/bin/prometheus"]
CMD ["--config.file=/opt/bitnami/prometheus/conf/prometheus.yml","--storage.tsdb.path=/opt/bitnami/prometheus/data","--web.console.libraries=/opt/bitnami/prometheus/conf/console_libraries","--web.console.templates=/opt/bitnami/prometheus/conf/consoles"]
