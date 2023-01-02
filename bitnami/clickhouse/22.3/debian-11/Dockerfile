FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="22.3.15-debian-11-r10" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/clickhouse" \
      org.opencontainers.image.title="clickhouse" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="22.3.15"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps xmlstarlet
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "gosu-1.16.0-0-linux-${OS_ARCH}-debian-11" \
      "clickhouse-22.3.15-0-linux-${OS_ARCH}-debian-11" \
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

COPY rootfs /
RUN /opt/bitnami/scripts/clickhouse/postunpack.sh
ENV APP_VERSION="22.3.15" \
    BITNAMI_APP_NAME="clickhouse" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/clickhouse/bin:$PATH" \
    clickhouseCTL_API="3"

EXPOSE 8123 9000 9004 9005 9009

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/clickhouse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/clickhouse/run.sh", "--", "--listen_host=0.0.0.0" ]
