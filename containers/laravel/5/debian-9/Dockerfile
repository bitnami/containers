FROM bitnami/minideb-extras:stretch

LABEL maintainer "Bitnami <containers@bitnami.com>"

# System packages required
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-dev libreadline-dev libncurses5 libtinfo5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng-dev libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0-dev libcurl3 libfreetype6 libicu57 libgcc1 libgcrypt20 libsasl2-2 libgnutls28-dev liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libp11-kit0 libtasn1-6 nettle-dev libhogweed4 libkrb5support0 libkeyutils1 libffi6 libsybdb5 libpq5

RUN bitnami-pkg install node-8.11.3-0 --checksum d312d68b2b8f85b96d8322187e1c6cb235f64717173ec775b2b02c4cb43c436c
RUN bitnami-pkg unpack php-7.1.19-3 --checksum f194bb974d4bdec0a359c6e8a4b1559c6dbc2b6864e1e2f88dd09f922e7b7658

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH
ENV PATH=/opt/bitnami/php/sbin:/opt/bitnami/php/bin:/opt/bitnami/common/bin:~/.composer/vendor/bin:$PATH
ENV NODE_PATH=/opt/bitnami/node/lib/node_modules

RUN npm install -g gulp

USER bitnami

RUN mkdir /tmp/app && cd /tmp/app && composer create-project "laravel/laravel=5.6.21" /tmp/app --prefer-dist

ENV BITNAMI_APP_NAME=laravel
ENV BITNAMI_IMAGE_VERSION=5.6.21-debian-9-r0

COPY rootfs/ /

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=3000"]
