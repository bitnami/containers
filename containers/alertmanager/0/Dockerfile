FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/alertmanager-0.14.0-0-linux-x64-debian-8.tar.gz && \
    echo "fc5e1906725c70aeffc02ec88009a438a39a8c81e5462cb183269741af3a2977  /tmp/bitnami/pkg/cache/alertmanager-0.14.0-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/alertmanager-0.14.0-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/alertmanager-0.14.0-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/alertmanager /opt/bitnami/alertmanager
ENV BITNAMI_APP_NAME="alertmanager" \
    BITNAMI_IMAGE_VERSION="0.14.0-r54" \
    PATH="/opt/bitnami/alertmanager/bin:$PATH"

RUN mkdir -p /opt/bitnami/alertmanager/data/ && chmod g+rwX /opt/bitnami/alertmanager/data/

EXPOSE 9093

WORKDIR /opt/bitnami/alertmanager
USER 1001
ENTRYPOINT ["/opt/bitnami/alertmanager/bin/alertmanager"]
CMD ["--config.file=/opt/bitnami/alertmanager/conf/config.yml","--storage.path=/opt/bitnami/alertmanager/data"]
