FROM bitnami/oraclelinux-extras:7-r167 as buildenv

RUN install_packages GeoIP ca-certificates curl cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nginx-ingress-controller-0.20.0-2-linux-x86_64-ol-7.tar.gz && \
    echo "9a4988aaee630031ca3a157c9ab302d3ddb8d195683933867d156cfb19b4f3ad  /tmp/bitnami/pkg/cache/nginx-ingress-controller-0.20.0-2-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nginx-ingress-controller-0.20.0-2-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nginx-ingress-controller-0.20.0-2-linux-x86_64-ol-7.tar.gz
RUN mkdir -p /opt/bitnami/nginx/conf/geoip && \
    cd /opt/bitnami/nginx/conf/geoip && \
    curl https://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz | gunzip >GeoIP.dat && \
    curl https://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz | gunzip >GeoLiteCity.dat && \
    curl http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz | gunzip >GeoIPASNum.dat

##################

FROM bitnami/oraclelinux-extras:7-r167
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/common /opt/bitnami/common
COPY --from=buildenv /opt/bitnami/lua /opt/bitnami/lua
COPY --from=buildenv /opt/bitnami/nginx /opt/bitnami/nginx
COPY --from=buildenv /opt/bitnami/nginx-ingress-controller /opt/bitnami/nginx-ingress-controller
ENV BITNAMI_APP_NAME="nginx-ingress-controller" \
    BITNAMI_IMAGE_VERSION="0.20.0-ol-7-r30" \
    PATH="/opt/bitnami/nginx-ingress-controller/bin:$PATH"

RUN rpm -Uvh https://s3.amazonaws.com/aaronsilber/public/authbind-2.1.1-0.1.x86_64.rpm
RUN ln -sf /opt/bitnami/nginx/sbin/nginx /usr/sbin/nginx
RUN ln -sf /opt/bitnami/nginx/conf /etc/nginx
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
    chown -R 1001 /etc/authbind/byport/* /etc/authbind/byuid/1001 && \
    chmod 755 /etc/authbind/byport/* /etc/authbind/byuid/1001
RUN chown -R 1001 /etc/nginx /etc/ingress-controller && \
    chmod -R g+rwX /opt/bitnami/nginx-ingress-controller
RUN chown -R 1001 /var/log/nginx && \
    chown -R 1001 /opt/bitnami/nginx/conf
RUN install_packages libcurl-devel python lua-devel GeoIP-devel ca-certificates

EXPOSE 80 443

WORKDIR /opt/bitnami/nginx-ingress-controller
USER 1001
ENTRYPOINT [ "nginx-ingress-controller" ]
