FROM gcr.io/stacksmith-images/minideb:jessie-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=symfony \
    BITNAMI_IMAGE_VERSION=3.2.4-r2 \
    PATH=/opt/bitnami/symfony/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0.0 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libsasl2-2 libgnutls-deb0-28 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libkrb5support0 libkeyutils1 libffi6 libsybdb5 libpq5

# Additional modules required
RUN bitnami-pkg install php-7.0.16-0 --checksum f59c28b5c169aca61cde263facd6472f10b66d211f361f87cf8244b5d6f1e280
RUN bitnami-pkg install mysql-client-10.1.21-1 --checksum 63155b08efa834316c47f29200a667f6d52506063dae861eb1edfba4266a9d62

# Install symfony
RUN bitnami-pkg install symfony-3.2.4-0 --checksum 5717ecd1f05745befa8ca0a746a5f11b0ed7a291e033350c001b616015ab6a5b

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
