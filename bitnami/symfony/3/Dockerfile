FROM bitnami/minideb-extras:jessie-r15

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=symfony \
    BITNAMI_IMAGE_VERSION=3.2.7-r1 \
    PATH=/opt/bitnami/symfony/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0.0 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libsasl2-2 libgnutls-deb0-28 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libkrb5support0 libkeyutils1 libffi6 libsybdb5 libpq5

# Additional modules required
RUN bitnami-pkg install php-7.0.18-0 --checksum 71c77e2a448543126606f054ae6dc85d893dc39e36d2bc55eb496f6910561a80
RUN bitnami-pkg install mysql-client-10.1.23-0 --checksum 9c38e41f237a4b9ce1aca7b9ecad86be5c55b924880cef45b87d635a4aea9d3d

# Install symfony
RUN bitnami-pkg install symfony-3.2.7-0 --checksum 94467cad103f89b215771a85ede024d53782d8d262d965e41d430b1bc0c76d68

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
