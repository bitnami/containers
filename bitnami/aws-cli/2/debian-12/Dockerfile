# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-01-07T20:51:20Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/aws-cli/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="2.22.30-debian-12-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/aws-cli" \
      org.opencontainers.image.title="aws-cli" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="2.22.30"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl groff-base libbz2-1.0 libcom-err2 libcrypt1 libffi8 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl3 libtinfo6 libtirpc3 procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "python-3.11.11-1-linux-${OS_ARCH}-debian-12" \
      "aws-cli-2.22.30-0-linux-${OS_ARCH}-debian-12" \
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
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

ENV APP_VERSION="2.22.30" \
    AWS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt" \
    BITNAMI_APP_NAME="aws-cli" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/aws-cli/bin:/opt/bitnami/aws-cli/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "aws" ]
CMD [ "--help" ]
