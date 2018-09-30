FROM bitnami/oraclelinux-extras:7-r122 as buildenv

RUN install_packages ca-certificates glibc libgcc libstdc++ wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-5.2.5-0-linux-x86_64-ol-7.tar.gz && \
    echo "7cabfecbe800506801f4b842e1bd03dc289c97cb2b04dd13f898e94fbd3e26bd  /tmp/bitnami/pkg/cache/grafana-5.2.5-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-5.2.5-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-5.2.5-0-linux-x86_64-ol-7.tar.gz
RUN mv /opt/bitnami/grafana/conf/sample.ini /opt/bitnami/grafana/conf/grafana.ini
RUN mkdir -p /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/ && chmod g+rwX /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/

##################

FROM bitnami/oraclelinux-extras:7-r122
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/grafana /opt/bitnami/grafana
ENV BITNAMI_APP_NAME="grafana" \
    BITNAMI_IMAGE_VERSION="5.2.5-ol-7-r5" \
    PATH="/opt/bitnami/grafana/bin:$PATH"

RUN install_packages curl
RUN install_packages fontconfig ca-certificates

EXPOSE 3000

COPY rootfs /
WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT [ "/run.sh" ]
