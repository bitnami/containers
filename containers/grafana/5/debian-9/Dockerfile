FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates libc6 libfontconfig libgcc1 libstdc++6 wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-5.3.2-0-linux-amd64-debian-9.tar.gz && \
    echo "9a226823d7a6ebf51d29cf4f271dbd0653da8773f608bd6c7e698de589aeaf55  /tmp/bitnami/pkg/cache/grafana-5.3.2-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-5.3.2-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-5.3.2-0-linux-amd64-debian-9.tar.gz
RUN mv /opt/bitnami/grafana/conf/sample.ini /opt/bitnami/grafana/conf/grafana.ini
RUN mkdir -p /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/ && chmod g+rwX /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/grafana /opt/bitnami/grafana
ENV BITNAMI_APP_NAME="grafana" \
    BITNAMI_IMAGE_VERSION="5.3.2-debian-9-r8" \
    PATH="/opt/bitnami/grafana/bin:$PATH"

RUN install_packages curl
RUN install_packages libfontconfig ca-certificates

EXPOSE 3000

COPY rootfs /
WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT [ "/run.sh" ]
