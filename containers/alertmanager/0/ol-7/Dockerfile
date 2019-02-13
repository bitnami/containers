FROM bitnami/oraclelinux-extras:7-r260
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/alertmanager-0.16.1-0-linux-x86_64-ol-7.tar.gz && \
    echo "aa723d5a61fad88d641ba561132e8c7bbe2b250fb0ac01eb1c81ae6bd6614077  /tmp/bitnami/pkg/cache/alertmanager-0.16.1-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/alertmanager-0.16.1-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/alertmanager-0.16.1-0-linux-x86_64-ol-7.tar.gz

RUN mkdir -p /opt/bitnami/alertmanager/data/ && chmod g+rwX /opt/bitnami/alertmanager/data/
ENV BITNAMI_APP_NAME="alertmanager" \
    BITNAMI_IMAGE_VERSION="0.16.1-ol-7-r10" \
    PATH="/opt/bitnami/alertmanager/bin:$PATH"

EXPOSE 9093

WORKDIR /opt/bitnami/alertmanager
USER 1001
ENTRYPOINT [ "/opt/bitnami/alertmanager/bin/alertmanager" ]
CMD [ "--config.file=/opt/bitnami/alertmanager/conf/config.yml", "--storage.path=/opt/bitnami/alertmanager/data" ]
