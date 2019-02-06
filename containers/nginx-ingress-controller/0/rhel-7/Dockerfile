FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages GeoIP GeoIP-devel ca-certificates curl cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libcurl-devel libgcc libidn libselinux libssh2 libstdc++ lua lua-devel nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre python wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nginx-ingress-controller-0.22.0-0-linux-x86_64-rhel-7.tar.gz && \
    echo "04d179a8b96f382b8f2855617b88c4c0526758c3e1929a83094feeaa022733d2  /tmp/bitnami/pkg/cache/nginx-ingress-controller-0.22.0-0-linux-x86_64-rhel-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nginx-ingress-controller-0.22.0-0-linux-x86_64-rhel-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nginx-ingress-controller-0.22.0-0-linux-x86_64-rhel-7.tar.gz
RUN mkdir -p /opt/bitnami/nginx/conf/geoip && \
    cd /opt/bitnami/nginx/conf/geoip && \
    curl https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz | tar xvz && mv GeoLite2-City_*/*mmdb . && rm -r GeoLite2-City_*/ && \
    curl https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz | tar xvz && mv GeoLite2-Country_*/*mmdb . && rm -r GeoLite2-Country_*/ && \
    curl https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz | tar xvz && mv GeoLite2-ASN_*/*mmdb . && rm -r GeoLite2-ASN_*/ &&\
    curl -L https://github.com/kubernetes/ingress-nginx/raw/master/images/nginx/rootfs/geoip/GeoIP.dat --output GeoIP.dat &&\
     curl -L https://github.com/kubernetes/ingress-nginx/raw/master/images/nginx/rootfs/geoip/GeoIPASNum.dat --output GeoIPASNum.dat &&\
    curl -L https://github.com/kubernetes/ingress-nginx/raw/master/images/nginx/rootfs/geoip/GeoLiteCity.dat --output GeoLiteCity.dat

RUN rpm -Uvh https://s3.amazonaws.com/aaronsilber/public/authbind-2.1.1-0.1.x86_64.rpm
RUN ln -sf /opt/bitnami/nginx/sbin/nginx /usr/sbin/nginx
RUN ln -sf /opt/bitnami/nginx/conf /etc/nginx && \
    ln -sf /opt/bitnami/nginx/modules /etc/nginx/modules
RUN ln -sf /opt/bitnami/nginx-ingress-controller/bin/nginx-ingress-controller /nginx-ingress-controller
RUN mkdir -p /etc/ingress-controller/auth /etc/ingress-controller/ssl
RUN ln -s /opt/bitnami/lua/lib/lua /usr/local/lib/lua
RUN ln -sf /opt/bitnami/nginx-ingress-controller/scripts /ingress-controller
RUN ln -sf /opt/bitnami/nginx/logs /var/log/nginx && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
RUN mkdir -p /etc/authbind/byport /etc/authbind/byuid && \
    touch /etc/authbind/byport/80 /etc/authbind/byport/443 && \
    printf "0.0.0.0:1-1023\n::0:1-1023" >/etc/authbind/byuid/1001 && \
    chown -R 1001:root /etc/authbind/byport/* /etc/authbind/byuid/1001 && \
    chmod 755 /etc/authbind/byport/* /etc/authbind/byuid/1001
RUN chown -R 1001:root /etc/nginx /etc/ingress-controller && \
    chmod -R g+rwX /opt/bitnami/nginx-ingress-controller /etc/nginx /etc/ingress-controller
RUN chown -R 1001:root /var/log/nginx && chmod g+rwX -R /var/log/nginx &&\
    chown -R 1001:root /opt/bitnami/nginx/conf && chmod g+rwX -R /opt/bitnami/nginx/conf
ENV BITNAMI_APP_NAME="nginx-ingress-controller" \
    BITNAMI_IMAGE_VERSION="0.22.0-rhel-7-r9" \
    BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/nginx-ingress-controller/bin:$PATH"

EXPOSE 80 443

WORKDIR /opt/bitnami/nginx-ingress-controller
USER 1001
ENTRYPOINT [ "nginx-ingress-controller" ]
