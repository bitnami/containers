FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.26-0 --checksum 2d01547a273e715388bae110707a41f458b5092193d31e6b726b5527a56a1eac
RUN bitnami-pkg unpack php-7.0.20-0 --checksum 78181d1320567be07448e75e4783ce0269b433fc9e7ed8eff67abcff7f7327e9
RUN bitnami-pkg install mysql-client-10.1.25-0 --checksum 513ef36ab1efa5570332547c2027ae29886fe4bb56472de11ca083423a3fe366
RUN bitnami-pkg install libphp-7.0.20-0 --checksum 9ec5ab2093723889e8c90e9e34f7434939c0c8d2ea054b4fc5af68e21f6ebaa5
RUN bitnami-pkg unpack piwik-3.0.4-0 --checksum 037a9a4b84bf8d920321a2623f38efb39b21fdef4469c02eb8742060e832fdad

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="piwik" \
    BITNAMI_IMAGE_VERSION="3.0.4-r5" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH" \
    PIWIK_EMAIL="user@example.com" \
    PIWIK_HOST="127.0.0.1" \
    PIWIK_PASSWORD="bitnami" \
    PIWIK_USERNAME="User" \
    PIWIK_WEBSITE_HOST="https://example.org" \
    PIWIK_WEBSITE_NAME="example" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""




EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
