FROM bitnami/minideb-extras:stretch-r494
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.41-3 --checksum 4cbd05e6df93361999856d4f77a4124443bc11b47abb090b3cfd19544cce627c
RUN bitnami-pkg unpack php-7.2.25-1 --checksum 43ffcf14b309e7d02f08e0187d32eea619fcc7712cd6b8467804b09fb7f87050
RUN bitnami-pkg unpack mysql-client-10.2.29-0 --checksum 1576cfcf1dcf9d64f6c508fe2711716a0bcddceeb891ab9cd926eff9e9288990
RUN bitnami-pkg install libphp-7.2.25-0 --checksum f6df242c9614ac3c8771b1150325859ce607251af3455f370b9802a6ab91b718
RUN bitnami-pkg unpack orangehrm-4.3.4-0-0 --checksum 035c98373b42423e422961a56939ed259e7f7652a24b667a1fcc7b357e47b4e1

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="orangehrm" \
    BITNAMI_IMAGE_VERSION="4.3.4-0-debian-9-r16" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    ORANGEHRM_DATABASE_NAME="bitnami_orangehrm" \
    ORANGEHRM_DATABASE_PASSWORD="" \
    ORANGEHRM_DATABASE_USER="bn_orangehrm" \
    ORANGEHRM_PASSWORD="Bitnami.12345" \
    ORANGEHRM_USERNAME="admin" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="none" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
