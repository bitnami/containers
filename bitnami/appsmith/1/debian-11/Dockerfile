FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.8.15-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/appsmith" \
      org.opencontainers.image.title="appsmith" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.8.15"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gettext libbz2-1.0 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgeoip1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libpcre3 libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "python-3.8.16-0-linux-${OS_ARCH}-debian-11" \
      "wait-for-port-1.0.5-1-linux-${OS_ARCH}-debian-11" \
      "render-template-1.0.4-1-linux-${OS_ARCH}-debian-11" \
      "node-16.19.0-0-linux-${OS_ARCH}-debian-11" \
      "nginx-1.23.3-0-linux-${OS_ARCH}-debian-11" \
      "mongodb-shell-1.6.1-1-linux-${OS_ARCH}-debian-11" \
      "java-11.0.17-7-2-linux-${OS_ARCH}-debian-11" \
      "gosu-1.16.0-0-linux-${OS_ARCH}-debian-11" \
      "appsmith-1.8.15-0-linux-${OS_ARCH}-debian-11" \
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
RUN /opt/bitnami/scripts/appsmith/postunpack.sh
RUN /opt/bitnami/scripts/nginx/postunpack.sh
ENV APP_VERSION="1.8.15" \
    BITNAMI_APP_NAME="appsmith" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/node/bin:/opt/bitnami/nginx/sbin:/opt/bitnami/mongodb/bin:/opt/bitnami/java/bin:$PATH"

EXPOSE 3000 8080 8091 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/appsmith/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/appsmith/run.sh" ]
