FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/alertmanager-0.23.0-0-linux-amd64-debian-10.tar.gz && \
    echo "b2565b3307ed43398b28e397562e647084844c37413b96074a694236524ff720  /tmp/bitnami/pkg/cache/alertmanager-0.23.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/alertmanager-0.23.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/alertmanager-0.23.0-0-linux-amd64-debian-10.tar.gz
RUN ln -sf /opt/bitnami/alertmanager/conf /etc/alertmanager
RUN ln -sf /opt/bitnami/alertmanager/data /alertmanager
RUN chmod g+rwX /opt/bitnami

RUN mkdir -p /opt/bitnami/alertmanager/data/ && chmod g+rwX /opt/bitnami/alertmanager/data/
ENV BITNAMI_APP_NAME="alertmanager" \
    BITNAMI_IMAGE_VERSION="0.23.0-debian-10-r127" \
    PATH="/opt/bitnami/alertmanager/bin:$PATH"

EXPOSE 9093

WORKDIR /opt/bitnami/alertmanager
USER 1001
ENTRYPOINT [ "/opt/bitnami/alertmanager/bin/alertmanager" ]
CMD [ "--config.file=/opt/bitnami/alertmanager/conf/config.yml", "--storage.path=/opt/bitnami/alertmanager/data" ]
