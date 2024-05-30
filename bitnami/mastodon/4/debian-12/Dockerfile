# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2024-05-30T15:32:10Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/mastodon/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="4.2.9-debian-12-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/mastodon" \
      org.opencontainers.image.title="mastodon" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="4.2.9"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ffmpeg file imagemagick libbrotli1 libbsd0 libbz2-1.0 libcom-err2 libcrypt1 libcurl4 libedit2 libffi8 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libicu72 libidn12 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.5-0 liblz4-1 liblzma5 libmd0 libncursesw6 libnettle8 libnghttp2-14 libnsl2 libp11-kit0 libpcre2-8-0 libpq5 libpsl5 libreadline-dev libreadline8 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl-dev libssl3 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libunistring2 libuuid1 libxml2 libxslt1.1 libyaml-0-2 libyaml-dev libzstd1 procps sqlite3 zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "python-3.11.9-10-linux-${OS_ARCH}-debian-12" \
      "wait-for-port-1.0.7-13-linux-${OS_ARCH}-debian-12" \
      "ruby-3.2.4-10-linux-${OS_ARCH}-debian-12" \
      "redis-client-7.0.15-4-linux-${OS_ARCH}-debian-12" \
      "postgresql-client-16.3.0-2-linux-${OS_ARCH}-debian-12" \
      "node-20.14.0-0-linux-${OS_ARCH}-debian-12" \
      "mastodon-4.2.9-0-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY rootfs /
RUN /opt/bitnami/scripts/mastodon/postunpack.sh
ENV APP_VERSION="4.2.9" \
    BITNAMI_APP_NAME="mastodon" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/redis/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/mastodon/bin:$PATH"

EXPOSE 3000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mastodon/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mastodon/run.sh" ]
