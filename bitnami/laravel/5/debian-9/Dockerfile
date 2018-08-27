FROM bitnami/minideb-extras:stretch

LABEL maintainer "Bitnami <containers@bitnami.com>"

# System packages required
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-dev libreadline-dev libncurses5 libtinfo5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng-dev libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0-dev libcurl3 libfreetype6 libicu57 libgcc1 libgcrypt20 libsasl2-2 libgnutls28-dev liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libp11-kit0 libtasn1-6 nettle-dev libhogweed4 libkrb5support0 libkeyutils1 libffi6 libsybdb5 libpq5

RUN bitnami-pkg install node-8.11.4-0 --checksum 53bef241a57487b05ec9de7e18136d6ca3d1b6d54e638d26ad7b71c47c423504
RUN bitnami-pkg unpack php-7.1.21-0 --checksum 7bad7c55c9e7d29e8a81baf753140eaacc40b70c588c45b462f3d6d9850352ef

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH
ENV PATH=/opt/bitnami/php/sbin:/opt/bitnami/php/bin:/opt/bitnami/common/bin:~/.composer/vendor/bin:$PATH
ENV NODE_PATH=/opt/bitnami/node/lib/node_modules

RUN npm install -g gulp

USER bitnami

RUN mkdir /tmp/app && cd /tmp/app && composer create-project "laravel/laravel=5.6.33" /tmp/app --prefer-dist

ENV BITNAMI_APP_NAME=laravel
ENV BITNAMI_IMAGE_VERSION=5.6.33-r0

COPY rootfs/ /

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=3000"]
