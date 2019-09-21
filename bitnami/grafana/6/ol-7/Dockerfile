FROM bitnami/oraclelinux-extras:7-r473
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl fontconfig fontconfig-devel glibc libgcc libstdc++ wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-6.3.5-2-linux-x86_64-ol-7.tar.gz && \
    echo "f0f2338503228f74e9357e1b6f3b626ccccbfa1c69d2d95910b3bb16c66fa9eb  /tmp/bitnami/pkg/cache/grafana-6.3.5-2-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-6.3.5-2-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-6.3.5-2-linux-x86_64-ol-7.tar.gz
RUN mv /opt/bitnami/grafana/conf/sample.ini /opt/bitnami/grafana/conf/grafana.ini
RUN mkdir -p /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/ && chmod g+rwX /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/

COPY rootfs /
ENV BITNAMI_APP_NAME="grafana" \
    BITNAMI_IMAGE_VERSION="6.3.5-ol-7-r23" \
    PATH="/opt/bitnami/grafana/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT [ "/run.sh" ]
