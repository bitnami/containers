# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:1e1b4657a77f0d47e9220f0c37b9bf7802581b93214fff7d1bd2364c8bf22e8e" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bullseye" \
      org.opencontainers.image.created="2023-12-27T14:08:08Z" \
      org.opencontainers.image.description="Application packaged by VMware, Inc" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="2.8.0-debian-11-r0" \
      org.opencontainers.image.title="airflow-scheduler" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.8.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl krb5-user libbsd0 libbz2-1.0 libcdt5 libcgraph6 libcom-err2 libcrypt1 libedit2 libexpat1 libffi7 libgcc-s1 libgmp10 libgnutls30 libgss-dev libgssapi-krb5-2 libgvc6 libhogweed6 libicu67 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5-dev libkrb5support0 libldap-2.4-2 libltdl7 liblz4-1 liblzma5 libmariadb3 libmd0 libncursesw6 libnettle8 libnsl2 libp11-kit0 libpathplan4 libreadline8 libsasl2-2 libsasl2-modules libsqlite3-0 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtinfo6 libtirpc3 libunistring2 libuuid1 libxml2 libxmlsec1 libxmlsec1-openssl libxslt1.1 locales netbase procps tzdata zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "wait-for-port-1.0.7-4-linux-${OS_ARCH}-debian-11" \
      "python-3.11.7-2-linux-${OS_ARCH}-debian-11" \
      "postgresql-client-16.1.0-0-linux-${OS_ARCH}-debian-11" \
      "ini-file-1.4.6-4-linux-${OS_ARCH}-debian-11" \
      "airflow-scheduler-2.8.0-0-linux-${OS_ARCH}-debian-11" \
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
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN mkdir /.local && chmod g+rwX /.local

COPY rootfs /
RUN /opt/bitnami/scripts/airflow-scheduler/postunpack.sh
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
ENV AIRFLOW_HOME="/opt/bitnami/airflow" \
    APP_VERSION="2.8.0" \
    BITNAMI_APP_NAME="airflow-scheduler" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LD_LIBRARY_PATH="/opt/bitnami/airflow/venv/lib/python3.8/site-packages/numpy.libs:/opt/bitnami/python/lib:$LD_LIBRARY_PATH" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="airflow" \
    NSS_WRAPPER_GROUP="/opt/bitnami/airflow/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/airflow/nss_passwd" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/airflow/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/airflow-scheduler/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/airflow-scheduler/run.sh" ]
