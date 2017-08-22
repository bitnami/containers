FROM bitnami/minideb-extras:jessie-r21
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.27-0 --checksum 27b8591b6564856428e2a3480949d549316e2f7e5bd207faa7b8c6e3a9bb9cc0
RUN bitnami-pkg unpack php-7.0.22-0 --checksum 205c9587157116d8842e50a3e23d147fb06f495e61e22c8a96974eb3d7deae51
RUN bitnami-pkg install mysql-client-10.1.26-0 --checksum 731e07b76a06c8b7f2a0b79d528f2f1f37e49142f682ab27ab8f4edfc9176d83
RUN bitnami-pkg install libphp-7.0.22-0 --checksum 3fcf344e454baf0c0e7c94798f22aa823033891224a10d59883756ebd12bdf79
RUN bitnami-pkg unpack mediawiki-1.29.0-0 --checksum 50aed4b6592cd9ce05f3e7daa6dec84a67aae3d2e40497e417ddb8e742f5df91

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="mediawiki" \
    BITNAMI_IMAGE_VERSION="1.29.0-r1" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    MEDIAWIKI_EMAIL="user@example.com" \
    MEDIAWIKI_PASSWORD="bitnami1" \
    MEDIAWIKI_USERNAME="user" \
    MEDIAWIKI_WIKI_NAME="Bitnami MediaWiki" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_HOST_ID="" \
    SMTP_PASSWORD="" \
    SMTP_PORT=""

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
