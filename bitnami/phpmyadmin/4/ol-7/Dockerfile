FROM bitnami/oraclelinux-extras:7-r474
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-2 --checksum bf50a12c033c1ff0e1cb7696cc1abd29a132cc1c5225e9d2fdbb3c6584e349fe
RUN bitnami-pkg unpack php-7.3.9-2 --checksum 5c1255ac466225ad8a68d970ee6f6e2e246d39e01aeab455557ea267bd55160a
RUN bitnami-pkg install libphp-7.3.9-0 --checksum d571181cffcf99e28bf1a53f5664136b391f99996f1471ab426aa73e6f09eed2
RUN bitnami-pkg unpack phpmyadmin-4.9.0-1-1 --checksum 3e4e5d989ae22bf94e2f64ac03359262b5c4fa4d407fed47e9ce78d72e518d04

COPY rootfs /
ENV BITNAMI_APP_NAME="phpmyadmin" \
    BITNAMI_IMAGE_VERSION="4.9.0-1-ol-7-r111" \
    DATABASE_ENABLE_SSL="no" \
    DATABASE_HOST="mariadb" \
    DATABASE_PORT_NUMBER="3306" \
    DATABASE_SSL_CA="" \
    DATABASE_SSL_CA_PATH="" \
    DATABASE_SSL_CERT="" \
    DATABASE_SSL_CIPHERS="" \
    DATABASE_SSL_KEY="" \
    DATABASE_SSL_VERIFY="yes" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:$PATH" \
    PHPMYADMIN_ALLOW_ARBITRARY_SERVER="" \
    PHPMYADMIN_ALLOW_NO_PASSWORD="true" \
    REQUIRE_LOCAL="no"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
