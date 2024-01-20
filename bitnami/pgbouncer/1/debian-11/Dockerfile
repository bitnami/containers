# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:1e1b4657a77f0d47e9220f0c37b9bf7802581b93214fff7d1bd2364c8bf22e8e" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bullseye" \
      org.opencontainers.image.created="2024-01-20T01:34:37Z" \
      org.opencontainers.image.description="Application packaged by VMware, Inc" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="1.21.0-debian-11-r9" \
      org.opencontainers.image.title="pgbouncer" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.21.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libaudit1 libbsd0 libc-ares2 libcap-ng0 libedit2 libevent-2.1-7 libffi7 libgcc-s1 libgmp10 libgnutls30 libhogweed6 libicu67 libidn2-0 libldap-2.4-2 liblzma5 libmd0 libnettle8 libp11-kit0 libpam0g libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 locales procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "wait-for-port-1.0.7-5-linux-${OS_ARCH}-debian-11" \
      "postgresql-client-14.10.0-0-linux-${OS_ARCH}-debian-11" \
      "ini-file-1.4.6-5-linux-${OS_ARCH}-debian-11" \
      "pgbouncer-1.21.0-2-linux-${OS_ARCH}-debian-11" \
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
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
RUN /opt/bitnami/scripts/pgbouncer/postunpack.sh
ENV APP_VERSION="1.21.0" \
    BITNAMI_APP_NAME="pgbouncer" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NSS_WRAPPER_LIB="/opt/bitnami/common/lib/libnss_wrapper.so" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/pgbouncer/bin:$PATH"

EXPOSE 6432

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/pgbouncer/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/pgbouncer/run.sh" ]
