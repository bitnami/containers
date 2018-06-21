FROM bitnami/oraclelinux-extras:7-r13
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.33-4 --checksum 4e8daac4fc3f70870a856be2dbabe35c060bae4319da105a1cd38ea2335cc5a1
RUN bitnami-pkg unpack php-7.0.30-5 --checksum e29bbc4dd7b4d09ec2c2ea47516b0d4d6bec5425e83c25a940990642d554558e
RUN bitnami-pkg install libphp-7.0.30-8 --checksum d56f04ce65e0caabe624739aa5a1b4d0980b612edc5331b647c86457b1bc36e6
RUN bitnami-pkg unpack phpmyadmin-4.8.1-0 --checksum d87630c0fc050f2a7499b6e778a689b0f83273d8f6bb9401c8db924d90a51809

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="phpmyadmin" \
    BITNAMI_IMAGE_VERSION="4.8.1-ol-7-r1" \
    DATABASE_HOST="mariadb" \
    DATABASE_PORT_NUMBER="3306" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:$PATH" \
    PHPMYADMIN_ALLOW_ARBITRARY_SERVER="" \
    PHPMYADMIN_ALLOW_NO_PASSWORD="true" \
    REQUIRE_LOCAL="0"

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
