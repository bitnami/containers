FROM bitnami/minideb-extras:jessie-r24
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.29-1 --checksum 42114e87aafb1d519ab33451b6836873bca125d78ce7423c5f7f1de4a7198596
RUN bitnami-pkg unpack php-7.0.28-0 --checksum 998f187961dd91ad14bd08e692559a8e1f59441f634256554dfcc1ddcbbd8209
RUN bitnami-pkg install mysql-client-10.1.31-0 --checksum c5140f9fd386782201b78559972045018928a405df324564deb392c6c61073c1
RUN bitnami-pkg install libphp-7.0.28-0 --checksum a9d64e3bf9dd634710c8a9020735efa8f1bff6a6ffbb6b1f048d5d6cc9dccfc6
RUN bitnami-pkg unpack opencart-3.0.2-0-0 --checksum 027e86a84e087b121b5cd81dbd7489703b370605c8e6446776016246cd652092

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="opencart" \
    BITNAMI_IMAGE_VERSION="3.0.2-0-r3" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    OPENCART_EMAIL="user@example.com" \
    OPENCART_HOST="127.0.0.1" \
    OPENCART_PASSWORD="bitnami1" \
    OPENCART_USERNAME="user" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
