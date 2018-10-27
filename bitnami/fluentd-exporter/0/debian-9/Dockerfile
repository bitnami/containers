FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd-exporter-0.2.0-2-linux-amd64-debian-9.tar.gz && \
    echo "eb8d409fafa9ded93ca8fccb375aba82e38ee73d2bdd0baab6b7b87a6fc09a28  /tmp/bitnami/pkg/cache/fluentd-exporter-0.2.0-2-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd-exporter-0.2.0-2-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd-exporter-0.2.0-2-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/fluentd-exporter /opt/bitnami/fluentd-exporter
ENV BITNAMI_APP_NAME="fluentd-exporter" \
    BITNAMI_IMAGE_VERSION="0.2.0-debian-9-r104" \
    PATH="/opt/bitnami/fluentd-exporter/bin:$PATH"

EXPOSE 9309

WORKDIR /opt/bitnami/fluentd-exporter
USER 1001
ENTRYPOINT [ "fluentd_exporter" ]
