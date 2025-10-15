# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-10-15T00:34:21Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/rails/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/rails" \
      org.opencontainers.image.title="rails" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="8.0.3"

ENV OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git libaudit1 libbz2-1.0 libcap-ng0 libcrypt1 libffi8 libgcc-s1 libicu72 liblzma5 libmariadb3 libncurses6 libncursesw6 libpam0g libreadline-dev libreadline8 libsqlite3-0 libssl-dev libssl3 libstdc++6 libtinfo6 libxml2 libyaml-0-2 libyaml-dev pkg-config procps sqlite3 sudo unzip zlib1g zlib1g-dev
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "python-3.14.0-4-linux-${OS_ARCH}-debian-12" \
      "wait-for-port-1.0.10-3-linux-${OS_ARCH}-debian-12" \
      "ruby-3.2.9-2-linux-${OS_ARCH}-debian-12" \
      "node-24.10.0-0-linux-${OS_ARCH}-debian-12" \
      "mysql-client-12.0.2-0-linux-${OS_ARCH}-debian-12" \
      "rails-8.0.3-0-linux-${OS_ARCH}-debian-12" \
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
RUN /build/bitnami-user.sh
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY rootfs /
RUN /opt/bitnami/scripts/rails/postunpack.sh
ENV APP_VERSION="8.0.3" \
    BITNAMI_APP_NAME="rails" \
    IMAGE_REVISION="4" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/rails/entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
