FROM bitnami/oraclelinux-extras:7-r36 as buildenv

RUN install_packages ca-certificates libfontconfig wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-5.2.1-6-linux-x64-debian-8.tar.gz && \
    echo "cc927096e8decde1c7f21a355831f2a6c23f6fb25370c67d3360f80e66619816  /tmp/bitnami/pkg/cache/grafana-5.2.1-6-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-5.2.1-6-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-5.2.1-6-linux-x64-debian-8.tar.gz
RUN mv /opt/bitnami/grafana/conf/sample.ini /opt/bitnami/grafana/conf/grafana.ini
RUN mkdir -p /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/ && chmod g+rwX /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/

##################

FROM bitnami/oraclelinux-extras:7-r36
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/grafana /opt/bitnami/grafana
ENV BITNAMI_APP_NAME="grafana" \
    BITNAMI_IMAGE_VERSION="5.2.1-ol-7-r10" \
    PATH="/opt/bitnami/grafana/bin:$PATH"

RUN install_packages curl
RUN install_packages fontconfig ca-certificates

EXPOSE 3000

COPY rootfs /
WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT ["/run.sh"]
