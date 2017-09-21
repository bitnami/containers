FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.27-0 --checksum 27b8591b6564856428e2a3480949d549316e2f7e5bd207faa7b8c6e3a9bb9cc0
RUN bitnami-pkg unpack php-7.0.23-0 --checksum 3e566682b62dacbf35282b33cbfa3cb0ff18bcc3221083212545e3290f519e32
RUN bitnami-pkg install mysql-client-10.1.26-0 --checksum 731e07b76a06c8b7f2a0b79d528f2f1f37e49142f682ab27ab8f4edfc9176d83
RUN bitnami-pkg install libphp-7.0.23-0 --checksum 55325169df846dc1009f9b57bd1cb22cfa6bc7a330a10ff0d448e2a534dab534
RUN bitnami-pkg unpack owncloud-10.0.3-0 --checksum 1fca8aebc09dacaf2b82634c8a9e553444671b0b3b7279fcd78402d35a9454e4

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="owncloud" \
    BITNAMI_IMAGE_VERSION="10.0.3-r0" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    OWNCLOUD_EMAIL="user@example.com" \
    OWNCLOUD_HOST="" \
    OWNCLOUD_PASSWORD="bitnami" \
    OWNCLOUD_USERNAME="user" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH"

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
