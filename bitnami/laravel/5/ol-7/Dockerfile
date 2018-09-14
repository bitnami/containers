FROM bitnami/oraclelinux-extras:7-r13

LABEL maintainer "Bitnami <containers@bitnami.com>"

# System packages required
RUN install_packages bzip2-libs cyrus-sasl-lib freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline xz-libs zlib

RUN bitnami-pkg install node-8.12.0-0 --checksum 6434289ff999ae5c589fdc6825bc6d6416e206f9285ab356344902a294e4fc28
RUN bitnami-pkg unpack php-7.1.21-2 --checksum 1decf8ad769433d3330c158734de049dcafa0876da7ec70662749b9c0cd68b68

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH
ENV PATH=/opt/bitnami/php/sbin:/opt/bitnami/php/bin:/opt/bitnami/common/bin:~/.composer/vendor/bin:$PATH
ENV NODE_PATH=/opt/bitnami/node/lib/node_modules

RUN npm install -g gulp

USER bitnami

RUN mkdir /tmp/app && cd /tmp/app && composer create-project "laravel/laravel=5.7.0" /tmp/app --prefer-dist

ENV BITNAMI_APP_NAME=laravel
ENV BITNAMI_IMAGE_VERSION=5.7.0-ol-7-r0

COPY rootfs/ /

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=3000"]
