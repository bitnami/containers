# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-01-05T22:21:33Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/mongodb-sharded/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="8.0.4-debian-12-r1" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/mongodb-sharded" \
      org.opencontainers.image.title="mongodb-sharded" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="8.0.4"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbrotli1 libcom-err2 libcurl4 libffi8 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.5-0 libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl3 libtasn1-6 libunistring2 libzstd1 numactl procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "yq-4.44.6-0-linux-${OS_ARCH}-debian-12" \
      "wait-for-port-1.0.8-8-linux-${OS_ARCH}-debian-12" \
      "render-template-1.0.7-8-linux-${OS_ARCH}-debian-12" \
      "mongodb-shell-2.3.7-0-linux-${OS_ARCH}-debian-12" \
      "mongodb-8.0.4-0-linux-${OS_ARCH}-debian-12" \
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
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/liblog.sh /liblog.sh
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/mongodb-sharded/postunpack.sh
ENV APP_VERSION="8.0.4" \
    BITNAMI_APP_NAME="mongodb-sharded" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mongodb-sharded/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mongodb-sharded/run.sh" ]
