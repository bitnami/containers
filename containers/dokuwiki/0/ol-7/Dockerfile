FROM bitnami/oraclelinux-extras:7-r3
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetype glibc gmp keyutils-libs krb5-libs libcom_err libcurl libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libpng libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.33-3 --checksum 0611709446389dbf1b9a08ee4b8b447443e356e286a9c6dee312d55f72e465d6
RUN bitnami-pkg unpack php-7.0.30-3 --checksum 1de72790ae78f941b400212bba9f04201373b7573e679818a7f06edbb65cf473
RUN bitnami-pkg install libphp-7.0.30-6 --checksum 31cf8fe7e06aee8a9954e5205b9d49e7ec8c8eef4d260a9ed21e1955ec10a9f9
RUN bitnami-pkg unpack dokuwiki-0.20180422.201805030840-1 --checksum d6e6d2da49ee8f92eac0caa891e43da9a5f42f9b19e4dc6cd4f3aae8032fbc6f

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dokuwiki" \
    BITNAMI_IMAGE_VERSION="0.20180422.201805030840-ol-7-r0" \
    DOKUWIKI_EMAIL="user@example.com" \
    DOKUWIKI_FULL_NAME="Full Name" \
    DOKUWIKI_PASSWORD="bitnami1" \
    DOKUWIKI_USERNAME="superuser" \
    DOKUWIKI_WIKI_NAME="Bitnami DokuWiki" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:$PATH"

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
