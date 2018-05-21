FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/elasticsearch_exporter-1.0.2-0-linux-x64-debian-8.tar.gz && \
    echo "304aa76a642f8689529a874956aec7905e39cc895bb0e91276915b63739d9acf  /tmp/bitnami/pkg/cache/elasticsearch_exporter-1.0.2-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/elasticsearch_exporter-1.0.2-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/elasticsearch_exporter-1.0.2-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/elasticsearch_exporter /opt/bitnami/elasticsearch_exporter
ENV BITNAMI_APP_NAME="elasticsearch_exporter" \
    BITNAMI_IMAGE_VERSION="1.0.2-r2" \
    PATH="/opt/bitnami/elasticsearch_exporter/bin:$PATH"

EXPOSE 9108

WORKDIR /opt/bitnami/elasticsearch_exporter
USER 1001
ENTRYPOINT ["/opt/bitnami/elasticsearch_exporter/bin/elasticsearch_exporter"]
