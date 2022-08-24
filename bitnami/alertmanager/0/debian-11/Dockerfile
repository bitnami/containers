FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.24.0-debian-11-r29" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/alertmanager" \
      org.opencontainers.image.title="alertmanager" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.24.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/alertmanager-0.24.0-153-linux-amd64-debian-11.tar.gz && \
    echo "259cbbc81f3bf38cd2d40ec79db42e11e72b005fccfecec22e0c14f377c3e245  /tmp/bitnami/pkg/cache/alertmanager-0.24.0-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/alertmanager-0.24.0-153-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/alertmanager-0.24.0-153-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /opt/bitnami/alertmanager/conf /etc/alertmanager
RUN ln -sf /opt/bitnami/alertmanager/data /alertmanager
RUN chmod g+rwX /opt/bitnami

RUN mkdir -p /opt/bitnami/alertmanager/data/ && chmod g+rwX /opt/bitnami/alertmanager/data/
ENV APP_VERSION="0.24.0" \
    BITNAMI_APP_NAME="alertmanager" \
    PATH="/opt/bitnami/alertmanager/bin:$PATH"

EXPOSE 9093

WORKDIR /opt/bitnami/alertmanager
USER 1001
ENTRYPOINT [ "/opt/bitnami/alertmanager/bin/alertmanager" ]
CMD [ "--config.file=/opt/bitnami/alertmanager/conf/config.yml", "--storage.path=/opt/bitnami/alertmanager/data" ]
