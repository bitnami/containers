FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bullseye" \
      org.opencontainers.image.created="2023-05-05T15:27:56Z" \
      org.opencontainers.image.description="Application packaged by VMware, Inc" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="1.2.1-debian-11-r0" \
      org.opencontainers.image.title="pgpool-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.2.1"

ENV HOME="/" \
    OS_ARCH="${linux:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux" \
    PGPOOL_EXPORTER_VERSION="1.2.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "pgpool2_exporter-${PGPOOL_EXPORTER_VERSION}linux-${OS_ARCH}" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://github.com/pgpool/pgpool2_exporter/releases/download/v${PGPOOL_EXPORTER_VERSION}/${COMPONENT}.tar.gz" -O ; \
      fi && \
      tar -zxf "${COMPONENT}.tar.gz" && \
      mv "${COMPONENT}" /opt/bitnami/pgpool2-exporter && \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.2.1" \
    BITNAMI_APP_NAME="pgppol2-exporter" \
    PATH="/opt/bitnami/pgpool2-exporter:$PATH"

EXPOSE 9187

WORKDIR /opt/bitnami/pgpool2-exporter
USER 1001
ENTRYPOINT [ "pgpool2_exporter" ]