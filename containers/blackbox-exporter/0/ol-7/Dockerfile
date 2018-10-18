FROM bitnami/oraclelinux-extras:7-r141 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/blackbox-exporter-0.12.0-2-linux-x86_64-ol-7.tar.gz && \
    echo "1e1e3cf473c1ccab0d5cc8bc4aa2f61da0271fef2b52c9932ba94a8f892f9bae  /tmp/bitnami/pkg/cache/blackbox-exporter-0.12.0-2-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/blackbox-exporter-0.12.0-2-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/blackbox-exporter-0.12.0-2-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r141
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/blackbox-exporter /opt/bitnami/blackbox-exporter
ENV BITNAMI_APP_NAME="blackbox-exporter" \
    BITNAMI_IMAGE_VERSION="0.12.0-ol-7-r101" \
    PATH="/opt/bitnami/blackbox-exporter/bin:$PATH"

EXPOSE 9115

WORKDIR /opt/bitnami/blackbox-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/blackbox-exporter/bin/blackbox_exporter" ]
