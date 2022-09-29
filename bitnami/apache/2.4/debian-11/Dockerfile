FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.4.54-debian-11-r39" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/apache" \
      org.opencontainers.image.title="apache" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.4.54"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libcrypt1 libexpat1 libffi7 libgcc-s1 libgmp10 libgnutls30 libhogweed6 libicu67 libidn2-0 libldap-2.4-2 liblzma5 libnettle8 libnghttp2-14 libp11-kit0 libpcre3 libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libunistring2 libxml2 procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    for COMPONENT in "apache-2.4.54-156-linux-${OS_ARCH}-debian-11.tar.gz" \
                     "render-template-1.0.3-153-linux-${OS_ARCH}-debian-11.tar.gz" \
                     "gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz"; \
    do \
        if [ ! -f "${COMPONENT}" ]; then \
          curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}" -O ; \
          curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.sha256" -O ; \
        fi && \
        sha256sum -c "${COMPONENT}.sha256" && \
        tar -zxf "${COMPONENT}" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
        rm -rf "${COMPONENT}" "${COMPONENT}.sha256" \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/apache/postunpack.sh
ENV APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APP_VERSION="2.4.54" \
    BITNAMI_APP_NAME="apache" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/apache/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/apache/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/apache/run.sh" ]
