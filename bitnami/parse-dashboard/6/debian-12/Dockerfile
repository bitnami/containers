# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-01-08T23:48:46Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/parse-dashboard/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="6.0.0-debian-12-r4" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/parse-dashboard" \
      org.opencontainers.image.title="parse-dashboard" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="6.0.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl jq libbz2-1.0 libffi8 libgcc-s1 liblzma5 libncursesw6 libreadline8 libsqlite3-0 libssl3 libstdc++6 libtinfo6 procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "python-3.13.1-1-linux-${OS_ARCH}-debian-12" \
      "node-22.13.0-0-linux-${OS_ARCH}-debian-12" \
      "parse-dashboard-6.0.0-1-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN mkdir /.local && chmod g+rwX /.local

COPY rootfs /
RUN /opt/bitnami/scripts/parse-dashboard/postunpack.sh
ENV APP_VERSION="6.0.0" \
    BITNAMI_APP_NAME="parse-dashboard" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/parse-dashboard/bin:$PATH"

EXPOSE 3000 4040

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse-dashboard/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse-dashboard/run.sh" ]
