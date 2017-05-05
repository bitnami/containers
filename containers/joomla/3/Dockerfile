FROM bitnami/minideb-extras:jessie-r15

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=joomla \
    BITNAMI_IMAGE_VERSION=3.7.0-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH

# System packages required
RUN install_packages libaprutil1 libapr1 libc6 libuuid1 libexpat1 libssl1.0.0 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libstdc++6 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libsybdb5 libpq5

# Additional modules require
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg unpack php-5.6.30-3 --checksum af6c238825d4394fc6352c5ad48c1e6423e21520df927097dab592f0d4ad4662
RUN bitnami-pkg install libphp-5.6.30-1 --checksum a62cad2320fa2d141309e75663aed3d1bd82626d51b784678d18ec3f985d83bf
RUN bitnami-pkg install mysql-client-10.1.23-0 --checksum 9c38e41f237a4b9ce1aca7b9ecad86be5c55b924880cef45b87d635a4aea9d3d

# Install joomla
RUN bitnami-pkg unpack joomla-3.7.0-0 --checksum bfe3e609c3932a268ef714cbf81a8bea4619cb85cd69086f7d2454ef688fb5e7

COPY rootfs /

ENV APACHE_HTTP_PORT="80" \
    APACHE_HTTPS_PORT="443" \
    JOOMLA_FIRST_NAME="User" \
    JOOMLA_LAST_NAME="Name" \
    JOOMLA_USERNAME="user" \
    JOOMLA_PASSWORD="bitnami" \
    JOOMLA_EMAIL="user@example.com" \
    MARIADB_USER="root" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306"

VOLUME ["/bitnami/joomla", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
