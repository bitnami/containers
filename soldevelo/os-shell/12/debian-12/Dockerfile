# Copyright 2025 SolDevelo
# Based on Bitnami Kafka © Broadcom, Inc. (Apache-2.0)
# SPDX-License-Identifier: Apache-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-08-19T08:08:50Z" \
      org.opencontainers.image.description="Application packaged by SolDevelo, based on Bitnami's work" \
      org.opencontainers.image.documentation="https://github.com/soldevelo/containers/tree/main/soldevelo/os-shell/README.md" \
      org.opencontainers.image.source="https://github.com/soldevelo/containers/tree/main/soldevelo/os-shell" \
      org.opencontainers.image.title="os-shell" \
      org.opencontainers.image.vendor="SolDevelo" \
      org.opencontainers.image.version="12"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl jq procps
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "yq-4.47.1-2-linux-${OS_ARCH}-debian-12" \
      "wait-for-port-1.0.10-0-linux-${OS_ARCH}-debian-12" \
      "render-template-1.0.9-155-linux-${OS_ARCH}-debian-12" \
      "ini-file-1.4.9-0-linux-${OS_ARCH}-debian-12" \
      "scuttle-1.1.11-6-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

ENV APP_VERSION="12" \
    BITNAMI_APP_NAME="os-shell" \
    IMAGE_REVISION="51" \
    PATH="/opt/bitnami/common/bin:$PATH"

USER 1001
