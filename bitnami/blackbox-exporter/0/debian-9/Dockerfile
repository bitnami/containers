FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/blackbox-exporter-0.12.0-2-linux-amd64-debian-9.tar.gz && \
    echo "0ed1e31d9b1e01967fd42af418fa209e767f9c842634a7571cfcf2445fcff95b  /tmp/bitnami/pkg/cache/blackbox-exporter-0.12.0-2-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/blackbox-exporter-0.12.0-2-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/blackbox-exporter-0.12.0-2-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/blackbox-exporter /opt/bitnami/blackbox-exporter
ENV BITNAMI_APP_NAME="blackbox-exporter" \
    BITNAMI_IMAGE_VERSION="0.12.0-debian-9-r105" \
    PATH="/opt/bitnami/blackbox-exporter/bin:$PATH"

EXPOSE 9115

WORKDIR /opt/bitnami/blackbox-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/blackbox-exporter/bin/blackbox_exporter" ]
