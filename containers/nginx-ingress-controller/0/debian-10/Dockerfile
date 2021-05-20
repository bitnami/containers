FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libcap2-bin libcom-err2 libcurl4 libcurl4-openssl-dev libffi6 libgcc1 libgcrypt20 libgeoip-dev libgeoip1 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblua5.1-0 liblua5.1-dev liblzma5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpcre3-dev libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libunistring2 libxml2 procps python tar wget zlib1g zlib1g-dev
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nginx-ingress-controller-0.46.0-0-linux-amd64-debian-10.tar.gz && \
    echo "1949557a630773108c7d06384cd4abb447be1986f470851da9223cc4a0a85f53  /tmp/bitnami/pkg/cache/nginx-ingress-controller-0.46.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nginx-ingress-controller-0.46.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nginx-ingress-controller-0.46.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /opt/bitnami/nginx/conf/geoip && \
    cd /opt/bitnami/nginx/conf/geoip && \
    curl -fL https://github.com/kubernetes/ingress-nginx/raw/master/images/nginx/rootfs/etc/nginx/geoip/GeoIP.dat --output GeoIP.dat && \
    curl -fL https://github.com/kubernetes/ingress-nginx/raw/master/images/nginx/rootfs/etc/nginx/geoip/GeoIPASNum.dat --output GeoIPASNum.dat && \
    curl -fL https://github.com/kubernetes/ingress-nginx/raw/master/images/nginx/rootfs/etc/nginx/geoip/GeoLiteCity.dat --output GeoLiteCity.dat

RUN setcap cap_net_bind_service=+ep /opt/bitnami/nginx/sbin/nginx && \
    setcap -v cap_net_bind_service=+ep /opt/bitnami/nginx/sbin/nginx
RUN setcap cap_net_bind_service=+ep /opt/bitnami/nginx-ingress-controller/bin/nginx-ingress-controller && \
    setcap -v cap_net_bind_service=+ep /opt/bitnami/nginx-ingress-controller/bin/nginx-ingress-controller
RUN mkdir -p /usr/local/nginx/sbin && \
    ln -sf /opt/bitnami/nginx/sbin/nginx /usr/local/nginx/sbin/nginx
RUN ln -sf /opt/bitnami/nginx/conf /etc/nginx && \
    ln -sf /opt/bitnami/nginx/modules /etc/nginx/modules
RUN ln -sf /opt/bitnami/nginx-ingress-controller/bin/nginx-ingress-controller /nginx-ingress-controller
RUN mkdir -p /etc/ingress-controller/auth /etc/ingress-controller/ssl
RUN ln -s /opt/bitnami/lua/lib/lua /usr/local/lib/lua
RUN ln -sf /opt/bitnami/nginx-ingress-controller/scripts /ingress-controller
RUN mkdir -p /opt/bitnami/nginx/logs && \
    ln -sf /opt/bitnami/nginx/logs /var/log/nginx && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
RUN chown -LR www-data:root /etc/nginx /etc/ingress-controller
RUN chgrp -R root /var/log/nginx && \
    chmod g+rwX -R /var/log/nginx && \
    chgrp -R root /opt/bitnami/nginx/conf && \
    chmod g+rwX -R /opt/bitnami/nginx/conf && \
    chmod -R g+rwX /opt/bitnami/nginx-ingress-controller /etc/nginx /etc/ingress-controller
ENV BITNAMI_APP_NAME="nginx-ingress-controller" \
    BITNAMI_IMAGE_VERSION="0.46.0-debian-10-r17" \
    LUA_CPATH="/opt/bitnami/nginx/conf/lua/?.so;/opt/bitnami/lua/lib/lua/5.1/?.so;./?.so;/opt/bitnami/lua/lib/lua/?.so;;" \
    LUA_PATH="/opt/bitnami/lua/share/lua/5.1/?/init.lua;/opt/bitnami/lua/lib/lua/?.lua;/opt/bitnami/lua/lib/lua/5.1/?.lua;/opt/bitnami/nginx/conf/lua/?.lua;;" \
    PATH="/opt/bitnami/nginx-ingress-controller/bin:/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 80 443

WORKDIR /opt/bitnami/nginx-ingress-controller
USER 1001
ENTRYPOINT [ "nginx-ingress-controller" ]
