FROM bitnami/oraclelinux-extras:7-r51 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/elasticsearch-exporter-1.0.2-1-linux-x86_64-ol-7.tar.gz && \
    echo "422ea805db2f78e1d2a06449020af70bbe3444fce0b4a00f0bd1bc8b57473d2f  /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.0.2-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.0.2-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.0.2-1-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r51
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/elasticsearch-exporter /opt/bitnami/elasticsearch-exporter
ENV BITNAMI_APP_NAME="elasticsearch-exporter" \
    BITNAMI_IMAGE_VERSION="1.0.2-ol-7-r34" \
    PATH="/opt/bitnami/elasticsearch-exporter/bin:$PATH"

EXPOSE 9108

WORKDIR /opt/bitnami/elasticsearch-exporter
USER 1001
ENTRYPOINT ["/opt/bitnami/elasticsearch-exporter/bin/elasticsearch_exporter"]
