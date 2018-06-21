FROM bitnami/oraclelinux-extras:7-r13

LABEL maintainer "Bitnami <containers@bitnami.com>"

# System packages required
RUN install_packages bzip2-libs cyrus-sasl-lib freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline xz-libs zlib

RUN bitnami-pkg install node-8.11.3-0 --checksum 0f9b299a5add60d28a967ab89a269a7f313f500a26b43ca825c47d878dff137d
RUN bitnami-pkg unpack php-7.1.18-2 --checksum 852a27db8227b8c426b6cbc1a3c67f2ae211d478cc64a21919cac8b3361ff7a8

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH
ENV PATH=/opt/bitnami/php/sbin:/opt/bitnami/php/bin:/opt/bitnami/common/bin:~/.composer/vendor/bin:$PATH
ENV NODE_PATH=/opt/bitnami/node/lib/node_modules

RUN npm install -g gulp

USER bitnami

RUN mkdir /tmp/app && cd /tmp/app && composer create-project "laravel/laravel=5.6.21" /tmp/app --prefer-dist

ENV BITNAMI_APP_NAME=laravel
ENV BITNAMI_IMAGE_VERSION=5.6.21-ol-7-r0

COPY rootfs/ /

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=3000"]
