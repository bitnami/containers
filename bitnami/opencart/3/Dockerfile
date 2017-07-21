FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.27-0 --checksum 27b8591b6564856428e2a3480949d549316e2f7e5bd207faa7b8c6e3a9bb9cc0
RUN bitnami-pkg unpack php-5.6.31-0 --checksum 52b9c324a764055bdbb1b07f313f938d68f5ab3202f83be729fcd24e0bf8cfa6
RUN bitnami-pkg install mysql-client-10.1.25-0 --checksum 513ef36ab1efa5570332547c2027ae29886fe4bb56472de11ca083423a3fe366
RUN bitnami-pkg install libphp-5.6.31-0 --checksum 64482dba01e676c8c2014086642a3062732f7f64e967c1c199c99b7009656c02
RUN bitnami-pkg unpack opencart-3.0.2-0-0 --checksum 027e86a84e087b121b5cd81dbd7489703b370605c8e6446776016246cd652092

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="opencart" \
    BITNAMI_IMAGE_VERSION="3.0.2-0-r0" \
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
