FROM bitnami/oraclelinux-extras:7-r431
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib expat glibc keyutils-libs krb5-libs libcom_err libnghttp2 libselinux nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre zlib
RUN bitnami-pkg unpack apache-2.4.41-0 --checksum aaef16fb8778a04e8fc1d407b37d951354dec85b142086952d6fd7223764ae8d
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log
RUN chmod -R g+rwX /opt/bitnami/apache/tmp /opt/bitnami/apache/conf

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="8443" \
    APACHE_HTTP_PORT_NUMBER="8080" \
    APACHE_SET_HTTPS_PORT="no" \
    APACHE_SET_HTTP_PORT="no" \
    BITNAMI_APP_NAME="apache" \
    BITNAMI_IMAGE_VERSION="2.4.41-ol-7-r3" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/apache/bin:$PATH"

VOLUME [ "/certs" ]

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/opt/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
