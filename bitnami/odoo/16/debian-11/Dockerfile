# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:1e1b4657a77f0d47e9220f0c37b9bf7802581b93214fff7d1bd2364c8bf22e8e" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bullseye" \
      org.opencontainers.image.created="2024-01-15T07:22:37Z" \
      org.opencontainers.image.description="Application packaged by VMware, Inc" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="16.0.20240115-debian-11-r0" \
      org.opencontainers.image.title="odoo" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="16.0.20240115"

ENV OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl fontconfig libbsd0 libbz2-1.0 libc6 libcap2-bin libcom-err2 libcrypt1 libedit2 libffi7 libfreetype6 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblz4-1 liblzma5 libmd0 libncursesw6 libnettle8 libnsl2 libp11-kit0 libpng16-16 libpq5 libreadline8 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libunistring2 libuuid1 libx11-6 libxcb1 libxext6 libxml2 libxrender1 libxslt1.1 procps xfonts-75dpi xfonts-base zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "python-3.11.7-2-linux-${OS_ARCH}-debian-11" \
      "render-template-1.0.6-5-linux-${OS_ARCH}-debian-11" \
      "postgresql-client-16.1.0-0-linux-${OS_ARCH}-debian-11" \
      "node-18.19.0-0-linux-${OS_ARCH}-debian-11" \
      "odoo-16.0.20240115-0-linux-${OS_ARCH}-debian-11" \
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
RUN curl -sLO "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bullseye_${OS_ARCH}.deb" && \
    if [ "$OS_ARCH" = "amd64" ]; then \
      echo "9c687f0c58cf50e01f2a6375d2e34372f8feeec56a84690ea113d298fccadd98  wkhtmltox_0.12.6.1-3.bullseye_${OS_ARCH}.deb" | sha256sum -c - ; \
    else \
      echo "e73435a82cf21ba0387bfee32a193f221fa43e48dda6ed38b12e4c1b70c69728  wkhtmltox_0.12.6.1-3.bullseye_${OS_ARCH}.deb" | sha256sum -c - ; \
    fi && \
    dpkg -i "wkhtmltox_0.12.6.1-3.bullseye_${OS_ARCH}.deb" && \
    rm wkhtmltox_0.12.6.1-3.bullseye_${OS_ARCH}.deb

COPY rootfs /
RUN /opt/bitnami/scripts/odoo/postunpack.sh
ENV APP_VERSION="16.0.20240115" \
    BITNAMI_APP_NAME="odoo" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/odoo/bin:$PATH"

EXPOSE 3000 8069 8072

ENTRYPOINT [ "/opt/bitnami/scripts/odoo/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/odoo/run.sh" ]
