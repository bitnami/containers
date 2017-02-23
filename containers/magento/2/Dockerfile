FROM gcr.io/stacksmith-images/minideb:jessie-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=magento \
    BITNAMI_IMAGE_VERSION=2.1.5-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/apache/bin:/opt/bitnami/magento/bin/:$PATH

# System packages required
RUN install_packages libssl1.0.0 libaprutil1 libapr1 libc6 libuuid1 libexpat1 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libstdc++6 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libsybdb5 libpq5

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg unpack php-7.0.16-1 --checksum 870b6b92ef762fc3a49eeaa71dfa78bacabf50a5fa41f811cdd99a49844d9d9b
RUN bitnami-pkg install libphp-7.0.16-0 --checksum 91548c756818a24b9d5477d2cb09d4eff689a2c6ad51d2ef7cd99370020b6494
RUN bitnami-pkg install mysql-client-10.1.21-1 --checksum 63155b08efa834316c47f29200a667f6d52506063dae861eb1edfba4266a9d62

# Install magento
RUN bitnami-pkg unpack magento-2.1.5-0 --checksum 1724aebfe22e075c8eeffe91c41602a98be40e9b382dcd72399a638ca1e47d3b

COPY rootfs /

ENV APACHE_HTTP_PORT="80" \
    APACHE_HTTPS_PORT="443" \
    MAGENTO_USERNAME="user" \
    MAGENTO_PASSWORD="bitnami1" \
    MAGENTO_EMAIL="user@example.com" \
    MAGENTO_ADMINURI="admin" \
    MAGENTO_FIRSTNAME="FirstName" \
    MAGENTO_LASTNAME="LastName" \
    MAGENTO_MODE="developer" \
    MARIADB_USER="root" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306"

VOLUME ["/bitnami/magento", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
