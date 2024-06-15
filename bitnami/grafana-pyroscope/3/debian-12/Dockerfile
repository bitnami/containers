# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2024-06-15T01:05:00Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/grafana-pyroscope/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.0.0-debian-12-r6" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/grafana-pyroscope" \
      org.opencontainers.image.title="grafana-pyroscoppe" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="3.0.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "pyroscope_1.6.0_linux_${OS_ARCH}" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://github.com/grafana/pyroscope/releases/download/v1.6.0/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://github.com/grafana/pyroscope/releases/download/v1.6.0/checksums.txt" -O ; \
      fi ; \
      grep "${COMPONENT}.tar.gz" checksums.txt | sha256sum -c - ; \
      mkdir -p /opt/bitnami/grafana-pyroscope/bin ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami/grafana-pyroscope/bin --no-same-owner pyroscope; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /bitnami/grafana-pyroscope/data /bitnami/grafana-pyroscope/pyroscope && chmod -R g+rwX /bitnami/grafana-pyroscope && ln -s  /bitnami/grafana-pyroscope/pyroscope /etc/pyroscope && ln -s /bitnami/grafana-pyroscope/data /data
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

ENV APP_VERSION="3.0.0" \
    BITNAMI_APP_NAME="grafana-pyroscope" \
    PATH="/opt/bitnami/grafana-pyroscope/bin:$PATH"

EXPOSE 4040

USER 1001
ENTRYPOINT [ "pyroscope" ]
CMD [ "-server.http-listen-port", "4040"]

