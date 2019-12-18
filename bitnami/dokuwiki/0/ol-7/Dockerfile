FROM bitnami/oraclelinux-extras:7-r567
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-3 --checksum 30ae9f98466bc180ec5b3121b000e0a8ee36ee3434d4645c7c3aa22710cc6166
RUN bitnami-pkg unpack php-7.3.12-1 --checksum c809d01cf8f4542d340dda697674e919a4e96f95c5e409551a21562bc9446afe
RUN bitnami-pkg install libphp-7.3.12-0 --checksum fc2975089347f4f0b2e6bf404870234bf3e2be7747030f00b061456b49a1445c
RUN bitnami-pkg unpack dokuwiki-0.20180422.201901061035-2 --checksum b1bed0f232678dc7da788804bbd943d0eb7110289551901dc4f7eb50b1588939

COPY rootfs /
ENV BITNAMI_APP_NAME="dokuwiki" \
    BITNAMI_IMAGE_VERSION="0.20180422.201901061035-ol-7-r338" \
    DOKUWIKI_EMAIL="user@example.com" \
    DOKUWIKI_FULL_NAME="Full Name" \
    DOKUWIKI_PASSWORD="bitnami1" \
    DOKUWIKI_USERNAME="superuser" \
    DOKUWIKI_WIKI_NAME="Bitnami DokuWiki" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:$PATH"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
