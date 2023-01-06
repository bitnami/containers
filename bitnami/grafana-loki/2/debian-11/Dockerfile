FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.7.1-debian-11-r9" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/grafana-loki" \
      org.opencontainers.image.title="grafana-loki" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.7.1"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "grafana-loki-2.7.1-0-linux-${OS_ARCH}-debian-11" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi && \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" && \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /bitnami/grafana-loki/data /bitnami/grafana-loki/loki /bitnami/grafana-loki/wal && chmod -R g+rwX /bitnami/grafana-loki && ln -s  /bitnami/grafana-loki/loki /loki && ln -s /bitnami/grafana-loki/data /data && ln -s /bitnami/grafana-loki/wal /wal

ENV APP_VERSION="2.7.1" \
    BITNAMI_APP_NAME="grafana-loki" \
    PATH="/opt/bitnami/grafana-loki/bin:$PATH"

EXPOSE 3100

USER 1001
ENTRYPOINT [ "loki" ]
CMD [ "-config.file=/bitnami/grafana-loki/conf/loki.yaml" ]
