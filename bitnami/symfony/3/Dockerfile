FROM gcr.io/stacksmith-images/minideb:jessie-r11

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=symfony \
    BITNAMI_IMAGE_VERSION=3.2.6-r0 \
    PATH=/opt/bitnami/symfony/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0.0 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libsasl2-2 libgnutls-deb0-28 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libkrb5support0 libkeyutils1 libffi6 libsybdb5 libpq5

# Additional modules required
RUN bitnami-pkg install php-7.0.17-0 --checksum 70fb42218e5b75b81683e6b13034211dfe31a6488d90aa5c79e5edb52ed08ddf
RUN bitnami-pkg install mysql-client-10.1.22-1 --checksum d9c3d9a5c986ae17eaa5089d85dcd19f314f057102ab40121714e6e3b8c33af5

# Install symfony
RUN bitnami-pkg install symfony-3.2.6-0 --checksum 4b24caac0d6b83a84afe544cb7fe9f657a9b11951f4a09c24c3cfbedf61ef953

COPY rootfs /

ENV MARIADB_USER="root" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306" \
    SYMFONY_PROJECT_NAME="myapp" \
    TERM=xterm

WORKDIR /app

EXPOSE 8000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "-S", "0.0.0.0:8000"]
