FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="14.0.20221210-debian-11-r5" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/odoo" \
      org.opencontainers.image.title="odoo" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="14.0.20221210"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl fontconfig libbsd0 libbz2-1.0 libc6 libcap2-bin libcom-err2 libcrypt1 libedit2 libffi7 libfreetype6 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmd0 libncursesw6 libnettle8 libnsl2 libp11-kit0 libpng16-16 libpq5 libreadline8 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libunistring2 libuuid1 libx11-6 libxcb1 libxext6 libxml2 libxrender1 libxslt1.1 procps xfonts-75dpi xfonts-base zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "python-3.8.16-0-linux-${OS_ARCH}-debian-11" \
      "render-template-1.0.4-1-linux-${OS_ARCH}-debian-11" \
      "postgresql-client-15.1.0-0-linux-${OS_ARCH}-debian-11" \
      "node-14.21.2-0-linux-${OS_ARCH}-debian-11" \
      "odoo-14.0.20221210-0-linux-${OS_ARCH}-debian-11" \
      "gosu-1.16.0-0-linux-${OS_ARCH}-debian-11" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi && \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" && \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN if [ "$OS_ARCH" = "amd64" ]; then \
    curl -sLO "https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_${OS_ARCH}.deb" && \
    echo "dfab5506104447eef2530d1adb9840ee3a67f30caaad5e9bcb8743ef2f9421bd  wkhtmltox_0.12.5-1.buster_${OS_ARCH}.deb" | sha256sum -c - && \
    dpkg -i "wkhtmltox_0.12.5-1.buster_${OS_ARCH}.deb" && \
    rm wkhtmltox_0.12.5-1.buster_${OS_ARCH}.deb \
    ; fi

COPY rootfs /
RUN /opt/bitnami/scripts/odoo/postunpack.sh
ENV APP_VERSION="14.0.20221210" \
    BITNAMI_APP_NAME="odoo" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/odoo/bin:$PATH"

EXPOSE 3000 8069 8072

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/odoo/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/odoo/run.sh" ]
