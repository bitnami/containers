# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2026-04-27T20:58:02Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/airflow/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/airflow" \
      org.opencontainers.image.title="airflow" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="3.2.1"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl git krb5-user libbz2-1.0 libcrypt1 libffi8 libgcc-s1 libgmp10 libgnutls30 libgss-dev libhogweed6 libidn2-0 libkeyutils1 libkrb5-dev libldap-2.5-0 liblzma5 libncursesw6 libnettle8 libp11-kit0 libreadline8 libsasl2-2 libsasl2-modules libsqlite3-0 libssl3 libstdc++6 libtasn1-6 libtinfo6 libudev1 libunistring2 locales netbase openssh-client procps tzdata unixodbc zlib1g
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "python-3.13.13-4-linux-${OS_ARCH}-debian-12" \
      "nss-wrapper-1.1.16-0-linux-${OS_ARCH}-debian-12" \
      "ini-file-1.4.9-9-linux-${OS_ARCH}-debian-12" \
      "wait-for-port-1.0.10-9-linux-${OS_ARCH}-debian-12" \
      "mariadb-lib-12.2.2-3-linux-${OS_ARCH}-debian-12" \
      "airflow-3.2.1-1-linux-${OS_ARCH}-debian-12" \
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
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales && \
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
RUN /opt/bitnami/scripts/locales/generate-locales.sh
RUN mkdir /.local && chmod g+rwX /.local
RUN uninstall_packages curl

COPY rootfs /
RUN /opt/bitnami/scripts/airflow/postunpack.sh
ENV AIRFLOW_HOME="/opt/bitnami/airflow" \
    APP_VERSION="3.2.1" \
    BITNAMI_APP_NAME="airflow" \
    IMAGE_REVISION="1" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LD_LIBRARY_PATH="/opt/bitnami/airflow/venv/lib/python3.13/site-packages/numpy.libs:/opt/bitnami/mariadb/lib:/opt/bitnami/python/lib:$LD_LIBRARY_PATH" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="airflow" \
    NSS_WRAPPER_GROUP="/opt/bitnami/airflow/nss-wrapper/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/airflow/nss-wrapper/nss_passwd" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/airflow/venv/bin:$PATH"

EXPOSE 8080 8125 8793 8794

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/airflow/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/airflow/run.sh" ]
