# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-09-28T01:08:01Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/scylladb/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/scylladb" \
      org.opencontainers.image.title="scylladb" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="2025.3.1"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libatomic1 libblkid1 libbz2-1.0 libcap2 libcom-err2 libcrypt1 libffi8 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libjsoncpp25 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblz4-1 liblzma5 libmount1 libmpfr6 libncursesw6 libnettle8 libnsl2 libp11-kit0 libpcre2-8-0 libreadline8 libselinux1 libsmartcols1 libsqlite3-0 libssl3 libstdc++6 libsystemd0 libtasn1-6 libtinfo6 libtirpc3 libudev1 libunistring2 libxxhash0 libzstd1 procps rsyslog zlib1g
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "python-3.12.11-10-linux-${OS_ARCH}-debian-12" \
      "jre-11.0.28-12-1-linux-${OS_ARCH}-debian-12" \
      "scylladb-2025.3.1-0-linux-${OS_ARCH}-debian-12" \
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
RUN uninstall_packages curl

COPY rootfs /
RUN /opt/bitnami/scripts/scylladb/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="2025.3.1" \
    BITNAMI_APP_NAME="scylladb" \
    IMAGE_REVISION="4" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/scylladb/bin:/opt/bitnami/scylladb/sbin:/opt/bitnami/scylladb/python3/bin:/opt/bitnami/supervisor/bin:/opt/bitnami/scylladb/share/cassandra/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/scylladb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/scylladb/run.sh" ]
