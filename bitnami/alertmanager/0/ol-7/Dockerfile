FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip hostname libaio-devel procps-ng sudo tar wget which
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/alertmanager-0.20.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "fda3e0b58034be98cf3ed1963ac9566dfba5dd99ca2683d647a94feab7ea6181  /tmp/bitnami/pkg/cache/alertmanager-0.20.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/alertmanager-0.20.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/alertmanager-0.20.0-0-linux-x86_64-ol-7.tar.gz
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN ln -sf /opt/bitnami/alertmanager/conf /etc/alertmanager
RUN ln -sf /opt/bitnami/alertmanager/data /alertmanager

RUN mkdir -p /opt/bitnami/alertmanager/data/ && chmod g+rwX /opt/bitnami/alertmanager/data/
ENV BITNAMI_APP_NAME="alertmanager" \
    BITNAMI_IMAGE_VERSION="0.20.0-ol-7-r51" \
    PATH="/opt/bitnami/alertmanager/bin:$PATH"

EXPOSE 9093

WORKDIR /opt/bitnami/alertmanager
USER 1001
ENTRYPOINT [ "/opt/bitnami/alertmanager/bin/alertmanager" ]
CMD [ "--config.file=/opt/bitnami/alertmanager/conf/config.yml", "--storage.path=/opt/bitnami/alertmanager/data" ]
