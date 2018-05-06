FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/blackbox_exporter-0.12.0-0-linux-x64-debian-8.tar.gz && \
    tar -zxf /tmp/bitnami/pkg/cache/blackbox_exporter-0.12.0-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/blackbox_exporter-0.12.0-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/blackbox_exporter /opt/bitnami/blackbox_exporter
ENV BITNAMI_APP_NAME="blackbox_exporter" \
    BITNAMI_IMAGE_VERSION="0.12.0-r13" \
    PATH="/opt/bitnami/blackbox_exporter/bin:$PATH"

EXPOSE 9115

WORKDIR /opt/bitnami/blackbox_exporter
USER 1001
ENTRYPOINT ["/opt/bitnami/blackbox_exporter/bin/blackbox_exporter"]
