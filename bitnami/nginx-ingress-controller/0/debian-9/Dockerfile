FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates curl libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgeoip1 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libunistring0 wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nginx-ingress-controller-0.20.0-2-linux-amd64-debian-9.tar.gz && \
    echo "c197dd25b8acc2197ba04e62ca7a8ef607dd1b6c0e93feef19b7c12180227728  /tmp/bitnami/pkg/cache/nginx-ingress-controller-0.20.0-2-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nginx-ingress-controller-0.20.0-2-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nginx-ingress-controller-0.20.0-2-linux-amd64-debian-9.tar.gz
RUN mkdir -p /opt/bitnami/nginx/conf/geoip && \
    cd /opt/bitnami/nginx/conf/geoip && \
    curl https://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz | gunzip >GeoIP.dat && \
    curl https://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz | gunzip >GeoLiteCity.dat && \
    curl http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz | gunzip >GeoIPASNum.dat

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/common /opt/bitnami/common
COPY --from=buildenv /opt/bitnami/lua /opt/bitnami/lua
COPY --from=buildenv /opt/bitnami/nginx /opt/bitnami/nginx
COPY --from=buildenv /opt/bitnami/nginx-ingress-controller /opt/bitnami/nginx-ingress-controller
ENV BITNAMI_APP_NAME="nginx-ingress-controller" \
    BITNAMI_IMAGE_VERSION="0.20.0-debian-9-r33" \
    PATH="/opt/bitnami/nginx-ingress-controller/bin:$PATH"

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
RUN install_packages authbind zlib1g-dev libpcre3-dev libssl-dev libcurl4-openssl-dev python liblua5.1-dev libgeoip-dev ca-certificates

EXPOSE 80 443

WORKDIR /opt/bitnami/nginx-ingress-controller
USER 1001
ENTRYPOINT [ "nginx-ingress-controller" ]
