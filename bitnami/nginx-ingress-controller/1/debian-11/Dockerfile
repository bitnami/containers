FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.3.1-debian-11-r6" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/nginx-ingress-controller" \
      org.opencontainers.image.title="nginx-ingress-controller" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.3.1"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbrotli1 libc6 libcap2-bin libcom-err2 libcrypt1 libcurl4 libcurl4-openssl-dev libffi7 libgcc-s1 libgcrypt20 libgeoip-dev libgeoip1 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblua5.1-0 liblua5.1-dev liblzma5 libnettle8 libnghttp2-14 libp11-kit0 libpcre3 libpcre3-dev libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libunistring2 libxml2 procps tar zlib1g zlib1g-dev
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f nginx-ingress-controller-1.3.1-3-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/nginx-ingress-controller-1.3.1-3-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/nginx-ingress-controller-1.3.1-3-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c nginx-ingress-controller-1.3.1-3-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf nginx-ingress-controller-1.3.1-3-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf nginx-ingress-controller-1.3.1-3-linux-${OS_ARCH}-debian-11.tar.gz nginx-ingress-controller-1.3.1-3-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /opt/bitnami/nginx/conf/geoip && \
    cd /opt/bitnami/nginx/conf/geoip && \
    curl -fL https://github.com/kubernetes/ingress-nginx/raw/main/images/nginx/rootfs/etc/nginx/geoip/GeoIP.dat --output GeoIP.dat && \
    curl -fL https://github.com/kubernetes/ingress-nginx/raw/main/images/nginx/rootfs/etc/nginx/geoip/GeoIPASNum.dat --output GeoIPASNum.dat && \
    curl -fL https://github.com/kubernetes/ingress-nginx/raw/main/images/nginx/rootfs/etc/nginx/geoip/GeoLiteCity.dat --output GeoLiteCity.dat

RUN setcap cap_net_bind_service=+ep /opt/bitnami/nginx/sbin/nginx && \
    setcap -v cap_net_bind_service=+ep /opt/bitnami/nginx/sbin/nginx
RUN setcap cap_net_bind_service=+ep /opt/bitnami/nginx-ingress-controller/bin/nginx-ingress-controller && \
    setcap -v cap_net_bind_service=+ep /opt/bitnami/nginx-ingress-controller/bin/nginx-ingress-controller
RUN mkdir -p /usr/local/nginx/sbin && \
    ln -sf /opt/bitnami/nginx/sbin/nginx /usr/local/nginx/sbin/nginx && \
    mkdir -p /usr/bin && \
    ln -sf /opt/bitnami/nginx/sbin/nginx /usr/bin/nginx
RUN ln -sf /opt/bitnami/nginx/conf /etc/nginx && \
    ln -sf /opt/bitnami/nginx/modules /etc/nginx/modules
RUN ln -sf /opt/bitnami/nginx-ingress-controller/bin/nginx-ingress-controller /nginx-ingress-controller
RUN mkdir -p /etc/ingress-controller/auth /etc/ingress-controller/ssl
RUN ln -s /opt/bitnami/lua/lib/lua /usr/local/lib/lua
RUN mkdir -p /tmp/nginx
RUN ln -sf /opt/bitnami/nginx-ingress-controller/scripts /ingress-controller
RUN mkdir -p /opt/bitnami/nginx/logs && \
    ln -sf /opt/bitnami/nginx/logs /var/log/nginx && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
RUN chown -LR www-data:root /etc/nginx /etc/ingress-controller
RUN chgrp -R root /var/log && \
    chmod g+rwX -R /var/log && \
    chgrp -R root /opt/bitnami/nginx/conf && \
    chmod g+rwX -R /opt/bitnami/nginx/conf && \
    chmod -R g+rwX /opt/bitnami/nginx-ingress-controller /etc/nginx /etc/ingress-controller && \
    chmod g+rwX -R /tmp/nginx
ENV APP_VERSION="1.3.1" \
    BITNAMI_APP_NAME="nginx-ingress-controller" \
    LUA_CPATH="/opt/bitnami/nginx/conf/lua/?.so;/opt/bitnami/lua/lib/lua/5.1/?.so;./?.so;/opt/bitnami/lua/lib/lua/?.so;;" \
    LUA_PATH="/opt/bitnami/lua/share/lua/5.1/?/init.lua;/opt/bitnami/lua/lib/lua/?.lua;/opt/bitnami/lua/lib/lua/5.1/?.lua;/opt/bitnami/nginx/conf/lua/?.lua;;" \
    PATH="/opt/bitnami/nginx-ingress-controller/bin:/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 80 443

WORKDIR /opt/bitnami/nginx-ingress-controller
USER 1001
ENTRYPOINT [ "nginx-ingress-controller" ]
