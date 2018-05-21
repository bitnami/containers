FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd_exporter-0.2.0-0-linux-x64-debian-8.tar.gz && \
    echo "23a95553173e305f991bdc41b1fd33b2f9366afbd6ba4f578cdf1d04eb59b718  /tmp/bitnami/pkg/cache/fluentd_exporter-0.2.0-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd_exporter-0.2.0-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd_exporter-0.2.0-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/fluentd_exporter /opt/bitnami/fluentd_exporter
ENV BITNAMI_APP_NAME="fluentd_exporter" \
    BITNAMI_IMAGE_VERSION="0.2.0-r2" \
    PATH="/opt/bitnami/fluentd_exporter/bin:$PATH"

EXPOSE 9309

WORKDIR /opt/bitnami/fluentd_exporter
USER 1001
ENTRYPOINT ["fluentd_exporter"]
