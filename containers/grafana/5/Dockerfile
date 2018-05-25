FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-5.0.4-0-linux-x64-debian-8.tar.gz && \
    echo "75619cd6925bc3c96b534697e441f96e33a5db6054645ffa946385791b3ff53b  /tmp/bitnami/pkg/cache/grafana-5.0.4-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-5.0.4-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-5.0.4-0-linux-x64-debian-8.tar.gz
RUN mkdir -p /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/ && chmod g+rwX /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/grafana /opt/bitnami/grafana
ENV BITNAMI_APP_NAME="grafana" \
    BITNAMI_IMAGE_VERSION="5.0.4-r5" \
    PATH="/opt/bitnami/grafana/bin:$PATH"

RUN install_packages libfontconfig ca-certificates

EXPOSE 3000

COPY rootfs /
WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT ["/run.sh"]
