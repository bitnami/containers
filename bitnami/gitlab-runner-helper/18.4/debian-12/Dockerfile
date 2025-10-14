# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-10-14T01:32:51Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/gitlab-runner-helper/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/gitlab-runner-helper" \
      org.opencontainers.image.title="gitlab-runner-helper" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="18.4.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl git git-lfs openssh-client procps
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "nss-wrapper-1.1.16-0-linux-${OS_ARCH}-debian-12" \
      "gitlab-runner-helper-18.4.0-2-linux-${OS_ARCH}-debian-12" \
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
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY rootfs /
RUN mkdir /home/gitlab-runner && \
    chmod +x /opt/bitnami/gitlab-runner-helper/bin/* && \
    chmod -R g+rwX /home/gitlab-runner && \
    ln -s /opt/bitnami/common/bin/dumb-init /usr/bin/dumb-init && \
    ln -s /opt/bitnami/scripts/gitlab-runner-helper/entrypoint.sh /entrypoint && \
    ln -s /opt/bitnami/gitlab-runner-helper/bin/gitlab-runner-helper /usr/bin/gitlab-runner-helper
ENV APP_VERSION="18.4.0" \
    BITNAMI_APP_NAME="gitlab-runner-helper" \
    IMAGE_REVISION="6" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/gitlab-runner-helper/bin:$PATH"

USER 1001
ENTRYPOINT [ "/usr/bin/dumb-init", "/opt/bitnami/scripts/gitlab-runner-helper/entrypoint.sh" ]
CMD [ "sh" ]
