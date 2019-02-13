FROM bitnami/minideb-extras:stretch-r283
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cron libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.38-1 --checksum 05c93df10a6e9fc17ee5f810045d80276fb394c1795667917f941d34c9f446e2
RUN bitnami-pkg unpack php-7.1.26-4 --checksum f754253881b698526840265dcbed1e77ef170fd74aa89c4bf2c5b1c8477061c9
RUN bitnami-pkg unpack mysql-client-10.1.38-0 --checksum 7202055a6688186df2570efea631940d25f5bb6ecd06f4e036c852d13ffded0c
RUN bitnami-pkg unpack libphp-7.1.26-2 --checksum 432d5083f0ab5559aa417caeae4de3e69c26516cce4b5d096fc2e3c442c48af7
RUN bitnami-pkg unpack suitecrm-7.11.1-0 --checksum 2a7626be5dd5a82035d63c181f7fa097adfaa265cf1449f84df22327a503c488
RUN sed -i -e '/pam_loginuid.so/ s/^#*/#/' /etc/pam.d/cron

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="suitecrm" \
    BITNAMI_IMAGE_VERSION="7.11.1-debian-9-r9" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    SUITECRM_DATABASE_NAME="bitnami_<<name>>" \
    SUITECRM_DATABASE_PASSWORD="" \
    SUITECRM_DATABASE_USER="bn_<<name>>" \
    SUITECRM_EMAIL="user@example.com" \
    SUITECRM_HOST="127.0.0.1" \
    SUITECRM_HTTP_TIMEOUT="120" \
    SUITECRM_LAST_NAME="Name" \
    SUITECRM_PASSWORD="bitnami" \
    SUITECRM_SMTP_HOST="" \
    SUITECRM_SMTP_PASSWORD="" \
    SUITECRM_SMTP_PORT="" \
    SUITECRM_SMTP_PROTOCOL="" \
    SUITECRM_SMTP_USER="" \
    SUITECRM_USERNAME="user" \
    SUITECRM_VALIDATE_USER_IP="yes"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
