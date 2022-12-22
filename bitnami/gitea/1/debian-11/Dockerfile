FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.17.4-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/gitea" \
      org.opencontainers.image.title="gitea" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.17.4"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl libbrotli1 libcom-err2 libcurl4 libffi7 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "gosu-1.16.0-0-linux-${OS_ARCH}-debian-11" \
      "wait-for-port-1.0.5-1-linux-${OS_ARCH}-debian-11" \
      "render-template-1.0.4-1-linux-${OS_ARCH}-debian-11" \
      "ini-file-1.4.4-1-linux-${OS_ARCH}-debian-11" \
      "git-2.39.0-0-linux-${OS_ARCH}-debian-11" \
      "gitea-1.17.4-0-linux-${OS_ARCH}-debian-11" \
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

COPY rootfs /
RUN /opt/bitnami/scripts/gitea/postunpack.sh
ENV APP_VERSION="1.17.4" \
    BITNAMI_APP_NAME="gitea" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/git/bin:/opt/bitnami/gitea/bin:$PATH"

EXPOSE 2222 3000

WORKDIR /opt/bitnami/gitea
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/gitea/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/gitea/run.sh" ]
