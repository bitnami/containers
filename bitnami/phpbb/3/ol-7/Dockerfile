FROM bitnami/oraclelinux-extras:7-r144
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.35-2 --checksum bdbe7184bb47bf2678ea322f7d17028d9741844dca75e2665626ad2f635a7b1c
RUN bitnami-pkg unpack php-7.1.23-0 --checksum 2bed406160aa91e888eda47df01d9d55a8fbba40b78f806ca2bc481c5aca0754
RUN bitnami-pkg unpack mysql-client-10.1.36-1 --checksum 37104f4fe6e526bbb437f61c33ecd8d14b2d576bc6d29b969daa252285acfd00
RUN bitnami-pkg unpack libphp-7.1.23-1 --checksum 841e4e865031b420226b1152d128988f7a15f95e77f47ff5296e9246b28a9042
RUN bitnami-pkg unpack phpbb-3.2.3-3 --checksum 48f6d87fd47607077590d999809c27a07cd8cf5cb58677193e3e50a9657a7be4

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="phpbb" \
    BITNAMI_IMAGE_VERSION="3.2.3-ol-7-r24" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    PHPBB_DATABASE_NAME="bitnami_phpbb" \
    PHPBB_DATABASE_PASSWORD="" \
    PHPBB_DATABASE_USER="bn_phpbb" \
    PHPBB_EMAIL="user@example.com" \
    PHPBB_FIRST_NAME="User" \
    PHPBB_FORUM_DESCRIPTION="A little text to describe your forum" \
    PHPBB_FORUM_NAME="My forum" \
    PHPBB_HOST="" \
    PHPBB_LAST_NAME="Name" \
    PHPBB_PASSWORD="bitnami" \
    PHPBB_USERNAME="user" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
