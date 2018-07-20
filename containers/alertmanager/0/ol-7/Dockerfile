FROM bitnami/oraclelinux-extras:7-r42 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/alertmanager-0.15.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "15013f1421efce08d359dbca445c14c8305a8d24290bc6e2c9cc4549d4e04318  /tmp/bitnami/pkg/cache/alertmanager-0.15.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/alertmanager-0.15.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/alertmanager-0.15.0-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r42
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/alertmanager /opt/bitnami/alertmanager
ENV BITNAMI_APP_NAME="alertmanager" \
    BITNAMI_IMAGE_VERSION="0.15.0-ol-7-r12" \
    PATH="/opt/bitnami/alertmanager/bin:$PATH"

RUN mkdir -p /opt/bitnami/alertmanager/data/ && chmod g+rwX /opt/bitnami/alertmanager/data/

EXPOSE 9093

WORKDIR /opt/bitnami/alertmanager
USER 1001
ENTRYPOINT ["/opt/bitnami/alertmanager/bin/alertmanager"]
CMD ["--config.file=/opt/bitnami/alertmanager/conf/config.yml","--storage.path=/opt/bitnami/alertmanager/data"]
