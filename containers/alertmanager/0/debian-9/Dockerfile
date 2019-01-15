FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/alertmanager-0.15.3-20-linux-amd64-debian-9.tar.gz && \
    echo "f97db3bcae87dee72fb530a94bf3224c0a5f38768d988727496b04f2ba04be65  /tmp/bitnami/pkg/cache/alertmanager-0.15.3-20-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/alertmanager-0.15.3-20-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/alertmanager-0.15.3-20-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/alertmanager /opt/bitnami/alertmanager
ENV BITNAMI_APP_NAME="alertmanager" \
    BITNAMI_IMAGE_VERSION="0.15.3-debian-9-r70" \
    PATH="/opt/bitnami/alertmanager/bin:$PATH"

RUN install_packages ca-certificates
RUN mkdir -p /opt/bitnami/alertmanager/data/ && chmod g+rwX /opt/bitnami/alertmanager/data/

EXPOSE 9093

WORKDIR /opt/bitnami/alertmanager
USER 1001
ENTRYPOINT [ "/opt/bitnami/alertmanager/bin/alertmanager" ]
CMD [ "--config.file=/opt/bitnami/alertmanager/conf/config.yml", "--storage.path=/opt/bitnami/alertmanager/data" ]
