FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.6.0-debian-11-r10" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/nginx-ingress-controller" \
      org.opencontainers.image.title="nginx-ingress-controller" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.6.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbrotli1 libcap2-bin libcom-err2 libcrypt1 libcurl4 libffi7 libgcc-s1 libgcrypt20 libgeoip1 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libnettle8 libnghttp2-14 libp11-kit0 libpcre3 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libunistring2 libxml2 procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "nginx-ingress-controller-1.6.0-1-linux-${OS_ARCH}-debian-11" \
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

RUN ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx && \
    ln -s /nginx-ingress-controller /usr/bin/nginx-ingress-controller
RUN cd /opt/bitnami/nginx-ingress-controller && \
    mkdir -p rootfs/etc/ingress-controller/ssl rootfs/etc/ingress-controller/auth rootfs/var/log/nginx rootfs/tmp/nginx && \
    if grep -q www-data /etc/passwd; then chown -R www-data rootfs/etc rootfs/var rootfs/tmp; fi && \
    chgrp -R root rootfs/etc rootfs/var rootfs/tmp && \
    chmod -R g+rwX rootfs/etc rootfs/var rootfs/tmp && \
    cp -rp rootfs/. / && \
    rm -rf rootfs && \
    ldconfig /usr/local/lib
RUN setcap    cap_net_bind_service=+ep /usr/local/nginx/sbin/nginx && \
    setcap -v cap_net_bind_service=+ep /usr/local/nginx/sbin/nginx
RUN setcap    cap_net_bind_service=+ep /nginx-ingress-controller && \
    setcap -v cap_net_bind_service=+ep /nginx-ingress-controller
RUN mkdir -p /etc/ingress-controller/auth /etc/ingress-controller/ssl
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
ENV APP_VERSION="1.6.0" \
    BITNAMI_APP_NAME="nginx-ingress-controller" \
    LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib:/modules_mount/etc/nginx/modules/otel" \
    LUA_CPATH="/usr/local/lib/lua/?/?.so;/usr/local/lib/lua/?.so;;" \
    LUA_PATH="/usr/local/share/luajit-2.1.0-beta3/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/lib/lua/?.lua;;" \
    PATH="/opt/bitnami/nginx-ingress-controller/bin:/opt/bitnami/nginx/sbin:$PATH:/usr/local/luajit/bin:/usr/local/nginx/sbin:/usr/local/nginx/bin"

EXPOSE 80 443

WORKDIR /etc/nginx
USER 1001
ENTRYPOINT [ "/nginx-ingress-controller" ]
