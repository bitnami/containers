FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.58.0-debian-11-r15" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/prometheus-operator" \
      org.opencontainers.image.title="prometheus-operator" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.58.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f prometheus-operator-0.58.0-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/prometheus-operator-0.58.0-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "7a720488737838b8ed8bd594ce9f3b97ae331e28f4400607bb9802edb17e0497  prometheus-operator-0.58.0-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf prometheus-operator-0.58.0-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf prometheus-operator-0.58.0-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/prometheus-operator/bin/prometheus-config-reloader /bin/prometheus-config-reloader
RUN ln -sf /opt/bitnami/prometheus-operator/bin/operator /bin/operator

ENV APP_VERSION="0.58.0" \
    BITNAMI_APP_NAME="prometheus-operator" \
    PATH="/opt/bitnami/prometheus-operator/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/prometheus-operator
USER 1001
ENTRYPOINT [ "/bin/operator" ]
