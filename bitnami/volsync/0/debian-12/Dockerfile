# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-10-08T04:46:31Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/volsync/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/volsync" \
      org.opencontainers.image.title="volsync" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="0.13.1"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl openssh-client openssh-server openssl perl procps rsync stunnel4
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "volsync-0.13.1-1-linux-${OS_ARCH}-debian-12" \
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
RUN useradd -r -u 1001 -g root volsync
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN sed -ir 's|^[#\s]*\(.*/etc/ssh/ssh_host_ecdsa_key\)$|#\1|' /etc/ssh/sshd_config && \
    sed -ir 's|^[#\s]*\(.*/etc/ssh/ssh_host_ed25519_key\)$|#\1|' /etc/ssh/sshd_config && \
    sed -ir 's|^[#\s]*\(PasswordAuthentication\)\s.*$|\1 no|' /etc/ssh/sshd_config && \
    sed -ir 's|^[#\s]*\(GSSAPIAuthentication\)\s.*$|\1 no|' /etc/ssh/sshd_config && \
    sed -ir 's|^[#\s]*\(AllowTcpForwarding\)\s.*$|\1 no|' /etc/ssh/sshd_config && \
    sed -ir 's|^[#\s]*\(X11Forwarding\)\s.*$|\1 no|' /etc/ssh/sshd_config && \
    sed -ir 's|^[#\s]*\(PermitTunnel\)\s.*$|\1 no|' /etc/ssh/sshd_config && \
    sed -ir 's|^[#\s]*\(PidFile\)\s.*$|\1 /tmp/sshd.pid|' /etc/ssh/sshd_config && \
    ln -s /opt/bitnami/volsync/mover-restic /mover-restic && \
    ln -s /opt/bitnami/volsync/mover-rsync /mover-rsync && \
    ln -s /opt/bitnami/volsync/mover-rclone /mover-rclone && \
    ln -s /opt/bitnami/volsync/mover-rsync-tls /mover-rsync-tls && \
    ln -s /opt/bitnami/volsync/mover-syncthing /mover-syncthing && \
    chmod +r /mover-restic/* /mover-rsync/* /mover-rsync-tls/* /mover-rclone/* /mover-syncthing/* && \
    chmod +x /mover-restic/*.sh /mover-rsync/*.sh /mover-rsync-tls/*.sh /mover-rclone/*.sh /mover-syncthing/*.sh
RUN uninstall_packages curl

ENV APP_VERSION="0.13.1" \
    BITNAMI_APP_NAME="volsync" \
    IMAGE_REVISION="2" \
    PATH="/opt/bitnami/volsync/bin:/opt/bitnami/rclone/bin:/opt/bitnami/diskrsync/bin:/opt/bitnami/syncthing/bin:$PATH"

USER 1001
