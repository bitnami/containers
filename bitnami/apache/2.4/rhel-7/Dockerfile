FROM gcr.io/helm-publish-ci/redhat-extras:7-r3
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/bitnami/apache/conf /opt/bitnami/apache/tmp /opt/bitnami/apache/conf" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib expat glibc keyutils-libs krb5-libs libcom_err libselinux nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre zlib
RUN bitnami-pkg unpack apache-2.4.33-4 --checksum cc2b7ea816858476f7cb475e1319219b88461af51a25e6ba96592e0bb560e9ca
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="8443" \
    APACHE_HTTP_PORT_NUMBER="8080" \
    BITNAMI_APP_NAME="apache" \
    BITNAMI_IMAGE_VERSION="2.4.33-rhel-7-r3" \
    PATH="/opt/bitnami/apache/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["httpd","-f","/bitnami/apache/conf/httpd.conf","-DFOREGROUND"]
