FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libfontconfig procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-8.1.5-0-linux-amd64-debian-10.tar.gz && \
    echo "db36c2aa3c0711860b7d501e13bae94ebadb7ebabb35d1f397d0d64aa407d677  /tmp/bitnami/pkg/cache/grafana-8.1.5-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-8.1.5-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-8.1.5-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/ && chown -R 1001:root /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/ && chmod g+rwX /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/
RUN mv /opt/bitnami/grafana/conf/sample.ini /opt/bitnami/grafana/conf/grafana.ini

COPY rootfs /
RUN /grafana-plugins.sh
ENV BITNAMI_APP_NAME="grafana" \
    BITNAMI_IMAGE_VERSION="8.1.5-debian-10-r2" \
    PATH="/opt/bitnami/grafana/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT [ "/run.sh" ]
