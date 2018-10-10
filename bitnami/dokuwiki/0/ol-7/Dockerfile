FROM bitnami/oraclelinux-extras:7-r133
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.35-0 --checksum 5d3d1836c2ff00e299779b9f5ad90f65e599655b6a96908c579966d206bb4396
RUN bitnami-pkg unpack php-7.1.22-2 --checksum 8f4ab141e851691e9238b18282f3eb62b985b6bd7df3459ba4648d32e3c01d09
RUN bitnami-pkg unpack libphp-7.1.22-2 --checksum 8abad49bc487f1db36bac51381c7cb17bbbeedfc1ffa095785545d862fc4af31
RUN bitnami-pkg unpack dokuwiki-0.20180422.201805030840-2 --checksum ac12980fc0558a07e2ece59984dddfceb809e9a04fe5fe924b292579c434ab73

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dokuwiki" \
    BITNAMI_IMAGE_VERSION="0.20180422.201805030840-ol-7-r92" \
    DOKUWIKI_EMAIL="user@example.com" \
    DOKUWIKI_FULL_NAME="Full Name" \
    DOKUWIKI_PASSWORD="bitnami1" \
    DOKUWIKI_USERNAME="superuser" \
    DOKUWIKI_WIKI_NAME="Bitnami DokuWiki" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:$PATH"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
