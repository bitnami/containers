FROM bitnami/minideb-extras:jessie-r24

LABEL maintainer "Bitnami <containers@bitnami.com>"

# System packages required
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0.0 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libsasl2-2 libgnutls-deb0-28 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libkrb5support0 libkeyutils1 libffi6 libsybdb5 libpq5

RUN bitnami-pkg install node-8.10.0-0 --checksum 651b299698ae1d3242dc99ec2193c530e6664e2be821fc4e72b32ffd0f41f676 
RUN bitnami-pkg unpack php-7.1.15-1 --checksum 2cd22fa0293f483a2fc26f8bdd14c04c92067bf8d064c08acf7d33998179bf27 

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH
ENV PATH=/opt/bitnami/php/sbin:/opt/bitnami/php/bin:/opt/bitnami/common/bin:~/.composer/vendor/bin:$PATH
ENV NODE_PATH=/opt/bitnami/node/lib/node_modules

RUN npm install -g gulp

USER bitnami

RUN mkdir /tmp/app && cd /tmp/app && composer create-project "laravel/laravel=5.6.12" /tmp/app --prefer-dist

ENV BITNAMI_APP_NAME=laravel
ENV BITNAMI_IMAGE_VERSION=5.6.12-r0

COPY rootfs/ /

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=3000"]
